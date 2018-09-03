function [dic, dAve, d, pD] = aqua_dic_tc(Theta, mu0, nSigmaSq0, nPre, Xi)
% [dic, dAve, d, pD] = aqua_dic_tc(Theta, mu0, nSigmaSq0, nPre, Xi) computes
% the DIC from MCMC output for the AQUA model.
%
% Input:
% Theta     - matrix of observed parameter vectors, where each row is an
%             observation, and each column is a parameter.
% mu0       - vector of the four initial conditional means.
% nSigmaSq0 - number of initial mean-adjusted observations to be averaged
%             over to compute the initial values of the conditional variance
%             recursions.
% nPre      - number of initial observations ignored by the likelihood
%             calculation (i.e., pre-sample size).
% Xi        - matrix of observations, where each row is an observation and
%             each column is a mapped parameter.
%
% Output:
% dic       - value of the DIC.
% dAve      - posterior mean of deviance.
% d         - deviance at posterior mean.
% pD        - effective number of parameters.
%
% Author: Wilson Ye Chen <wilsq.mail@gmail.com>
% Date:   May 8, 2018

    % Posterior mean of deviance
    nTheta = size(Theta, 1);
    ll = zeros(nTheta, 1);
    for i = 1:nTheta
        ll(i) = like(Theta(i, :), mu0, nSigmaSq0, nPre, Xi);
    end
    dAve = mean(-2 .* ll);

    % Deviance at posterior mean
    thtAve = mean(Theta, 1);
    ll = like(thtAve, mu0, nSigmaSq0, nPre, Xi);
    d = -2 .* ll;

    % DIC
    pD = dAve - d;
    dic = dAve + pD;
end

function ll = like(theta, mu0, nSigmaSq0, nPre, Xi)
    a = theta(1:8);
    b = theta(9:16);
    g = theta(17:24);
    h = theta(25:33);
    c = theta(34:39);
    df = theta(40);
    ll = aqua_like_tc(a, b, g, h, c, df, mu0, nSigmaSq0, nPre, Xi);
end
