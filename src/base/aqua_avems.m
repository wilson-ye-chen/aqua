function [MAve, SAve, wAve] = aqua_avems(Theta, mu0, nSigmaSq0, Xi)
% [MAve, SAve, wAve] = aqua_avems(Theta, mu0, nSigmaSq0, Xi) computes the
% conditional mean, standard deviation, and weight estimates by averaging
% over those given by the sampled parameters from the posterior distribution.
%
% Input:
% Theta     - matrix of sampled parameter vectors, where each row corresponds
%             to an observation and each column corresponds to a parameter.
% mu0       - vector of initial values of the conditional mean (for a, b, and
%             g) and conditional mode (for h) recursions.
% nSigmaSq0 - number of initial mean-adjusted observations to be averaged
%             over to compute the initial values of the conditional variance
%             recursions.
% Xi        - matrix of observations, where each row corresponds to an
%             observation and each column corresponds to a mapped parameter.
%
% Output:
% MAve      - matrix of average conditional means, containing one more row
%             than the number of observed parameter vectors, where the last
%             row is the out-of-sample one-period-ahead forecast.
% SAve      - matrix of average conditional standard deviations, containing
%             one more row than the number of observed parameter vectors,
%             where the last row is the out-of-sample one-period-ahead
%             forecast.
% wAve      - vector of average conditional weights, containing one more
%             element than the number of observed parameter vectors, where
%             the last element is the out-of-sample one-period-ahead forecast.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   October 11, 2016

    dtaA = Theta(:, 1);
    psiA = Theta(:, 2);
    phiA = Theta(:, 3);
    omgA = Theta(:, 4);
    alpA = Theta(:, 5);
    btaA = Theta(:, 6);
    dtaB = Theta(:, 9);
    psiB = Theta(:, 10);
    phiB = Theta(:, 11);
    omgB = Theta(:, 12);
    alpB = Theta(:, 13);
    btaB = Theta(:, 14);
    dtaG = Theta(:, 17);
    psiG = Theta(:, 18);
    phiG = Theta(:, 19);
    omgG = Theta(:, 20);
    alpG = Theta(:, 21);
    btaG = Theta(:, 22);
    dtaH = Theta(:, 25);
    psiH = Theta(:, 26);
    phiH = Theta(:, 27);
    lgmH = Theta(:, 28);
    ceeH = Theta(:, 29);
    sigH = Theta(:, 30);
    etaH = Theta(:, 31);
    ldaH = Theta(:, 32);
    iotH = Theta(:, 33);
    gamH = exp(lgmH);
    
    nTheta = size(Theta, 1);
    nObs = size(Xi, 1);
    MSum = zeros(nObs + 1, 4);
    SSum = zeros(nObs + 1, 3);
    wSum = zeros(nObs + 1, 1);
    for i = 1:nTheta
        % Conditional means
        muA = aqua_mu(dtaA(i), psiA(i), phiA(i), mu0(1), Xi(:, 1));
        muB = aqua_mu(dtaB(i), psiB(i), phiB(i), mu0(2), Xi(:, 2));
        muG = aqua_mu(dtaG(i), psiG(i), phiG(i), mu0(3), Xi(:, 3));
        muH = aqua_mu(dtaH(i), psiH(i), phiH(i), mu0(4), Xi(:, 4));
        w = 0.5 + 0.5 ./ (1 + exp(-gamH(i) .* (muH - ceeH(i))));
        mH = apatmean(muH, ...
            sigH(i), ...
            etaH(i), ...
            ldaH(i), ...
            iotH(i), ...
            w);
        M = [muA, muB, muG, mH];
        
        % Conditional standard deviation
        E = Xi(:, 1:3) - M(1:(end - 1), 1:3);
        sSq0 = var(E(1:nSigmaSq0, :), 1);
        sSqA = aqua_sigmasq(omgA(i), alpA(i), btaA(i), sSq0(1), E(:, 1));
        sSqB = aqua_sigmasq(omgB(i), alpB(i), btaB(i), sSq0(2), E(:, 2));
        sSqG = aqua_sigmasq(omgG(i), alpG(i), btaG(i), sSq0(3), E(:, 3));
        S = sqrt([sSqA, sSqB, sSqG]);
        
        % Cumulative sums
        MSum = MSum + M;
        SSum = SSum + S;
        wSum = wSum + w;
    end
    MAve = MSum ./ nTheta;
    SAve = SSum ./ nTheta;
    wAve = wSum ./ nTheta;
end
