function [Xi, Mu, SigmaSq, w] = aqua_sim_tc( ...
    a, b, g, h, c, df, mu0, sigmaSq0, nPre, nObs)
% [Xi, Mu, SigmaSq, w] = aqua_sim_tc(a, b, g, h, c, df, mu0, sigmaSq0, ...
% nPre, nObs) simulates from the gh-AQUA model, where the dependencies are
% modelled using a t-copula, the conditional marginal distributions of a,
% log(b), and g are skewed-t, and those of h are Apatosaurus.
%
% Input:
% a        - vector of parameters of the marginal model of a.
% b        - vector of parameters of the maringal model of log(b).
% g        - vector of parameters of the maringal model of g.
% h        - vector of parameters of the marginal model of h.
% c        - vector of correlations.
% df       - degrees-of-freedom parameter of the t-copula.
% mu0      - vector of initial values of the conditional mean recursions.
% sigmaSq0 - vector of initial values of the conditional variance recursions.
% nPre     - number of pre-samples; number of discarded observations at the
%            start of the recursions.
% nObs     - number of simulated observations.
%
% Output:
% Xi       - matrix of simulated observations, where each row is an
%            observation and each column is a mapped parameter.
% Mu       - matrix of simulated conditional means (for a, b, and g) and
%            conditional modes (for h).
% SigmaSq  - matrix of simulated conditional variances (for a, b, and g).
% w        - vector of simulated conditional weights (for h).
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   November 30, 2015

    % Simulate from the t-copula
    X = mvtrnd(c2r(c), df, nObs + nPre);
    U = tcdf(X, df);
    
    % Simulate from each marginal model
    [xiA, muA, sigmaSqA] = aqua_sim_sktmar( ...
        a(1), a(2), a(3), ...
        a(4), a(5), a(6), ...
        a(7), a(8), ...
        mu0(1), sigmaSq0(1), U(:, 1));
    [xiB, muB, sigmaSqB] = aqua_sim_sktmar( ...
        b(1), b(2), b(3), ...
        b(4), b(5), b(6), ...
        b(7), b(8), ...
        mu0(2), sigmaSq0(2), U(:, 2));
    [xiG, muG, sigmaSqG] = aqua_sim_sktmar( ...
        g(1), g(2), g(3), ...
        g(4), g(5), g(6), ...
        g(7), g(8), ...
        mu0(3), sigmaSq0(3), U(:, 3));
    [xiH, muH, w] = aqua_sim_apatmar( ...
        h(1), h(2), h(3), h(4), h(5), ...
        h(6), h(7), h(8), h(9), ...
        mu0(4), U(:, 4));
    
    % Construct output matrices
    Xi = [xiA, xiB, xiG, xiH];
    Mu = [muA, muB, muG, muH];
    SigmaSq = [sigmaSqA, sigmaSqB, sigmaSqG];
    
    % Discard the pre-sample observations
    Xi = Xi((nPre + 1):end, :);
    Mu = Mu((nPre + 1):end, :);
    SigmaSq = SigmaSq((nPre + 1):end, :);
    w = w((nPre + 1):end);
end

function R = c2r(c)
    R = [ ...
        1, c(1), c(2), c(3); ...
        c(1), 1, c(4), c(5); ...
        c(2), c(4), 1, c(6); ...
        c(3), c(5), c(6), 1 ...
        ];
end
