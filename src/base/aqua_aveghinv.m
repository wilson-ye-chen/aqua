function QAve = aqua_aveghinv(u, Theta, mu0, Xi)
% QAve = aqua_aveghinv(u, Theta, mu0, Xi) computes the conditional quantile
% estimates by averaging over those given by the sampled parameters from the
% posterior distribution.
%
% Input:
% u     - vector of quantile levels.
% Theta - matrix of sampled parameter vectors, where each row corresponds to
%         an observation and each column corresponds to a parameter.
% mu0   - vector of initial values of the conditional mean recursions.
% Xi    - matrix of observations, where each row corresponds to an observation
%         and each column corresponds to a mapped parameter.
%
% Output:
% QAve  - matrix of average conditional quantiles, containing one more row
%         than the number of observed parameter vectors, where the last row
%         is the out-of-sample one-period-ahead forecast.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   October 11, 2016

    dtaA = Theta(:, 1);
    psiA = Theta(:, 2);
    phiA = Theta(:, 3);
    dtaB = Theta(:, 9);
    psiB = Theta(:, 10);
    phiB = Theta(:, 11);
    dtaG = Theta(:, 17);
    psiG = Theta(:, 18);
    phiG = Theta(:, 19);
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
    nQAve = size(Xi, 1) + 1;
    UMat = repmat(u(:)', nQAve, 1);
    QSum = zeros(nQAve, numel(u));
    for i = 1:nTheta
        muA = aqua_mu(dtaA(i), psiA(i), phiA(i), mu0(1), Xi(:, 1));
        muB = aqua_mu(dtaB(i), psiB(i), phiB(i), mu0(2), Xi(:, 2));
        muG = aqua_mu(dtaG(i), psiG(i), phiG(i), mu0(3), Xi(:, 3));
        muH = aqua_mu(dtaH(i), psiH(i), phiH(i), mu0(4), Xi(:, 4));
        wH = 0.5 + 0.5 ./ (1 + exp(-gamH(i) .* (muH - ceeH(i))));
        mH = apatmean(muH, ...
            sigH(i), ...
            etaH(i), ...
            ldaH(i), ...
            iotH(i), ...
            wH);
        Gh = [muA, exp(muB), muG, mH];
        QSum = QSum + ghinv(UMat, Gh);
    end
    QAve = QSum ./ nTheta;
end
