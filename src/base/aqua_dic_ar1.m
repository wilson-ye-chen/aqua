function [dic, dAve, d, pD] = aqua_dic_ar1(Theta, mu0, nPre, Xi)
% [dic, dAve, d, pD] = aqua_dic_ar1(Theta, mu0, nPre, Xi) computes the DIC
% from MCMC output for the AQUA-AR(1) model.
%
% Input:
% Theta - matrix of observed parameter vectors, where each row is an
%         observation, and each column is a parameter.
% mu0   - vector of the four initial conditional means.
% nPre  - number of initial observations ignored by the likelihood calculation
%         (i.e., pre-sample size).
% Xi    - matrix of observations, where each row is an observation and each
%         column is a mapped parameter.
%
% Output:
% dic   - value of the DIC.
% dAve  - posterior mean of deviance.
% d     - deviance at posterior mean.
% pD    - effective number of parameters.
%
% Author: Wilson Ye Chen <wilsq.mail@gmail.com>
% Date:   May 8, 2018

    % Posterior mean of deviance
    nTheta = size(Theta, 1);
    ll = zeros(nTheta, 1);
    for i = 1:nTheta
        ll(i) = like(Theta(i, :), mu0, nPre, Xi);
    end
    dAve = mean(-2 .* ll);

    % Deviance at posterior mean
    thtAve = mean(Theta, 1);
    ll = like(thtAve, mu0, nPre, Xi);
    d = -2 .* ll;

    % DIC
    pD = dAve - d;
    dic = dAve + pD;
end

function ll = like(theta, mu0, nPre, Xi)
    lli = zeros(4, 1);
    for i = 1:4
        k = (i - 1) .* 3 + 1;
        dta = theta(k);
        psi = theta(k + 1);
        sig = theta(k + 2);
        lli(i) = aqua_like_ar1mar(dta, psi, sig, mu0(i), nPre, Xi(:, i));
    end
    ll = sum(lli);
end
