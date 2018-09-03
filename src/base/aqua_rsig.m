function RSig = aqua_rsig(Theta, muH0, nPreH, Xi)
% RSig = aqua_rsig(Theta, muH0, nPreH, Xi) generates a sample from the
% posterior of the signal ratio for each margin, based on MCMC output.
%
% Input:
% Theta - matrix of sampled parameter vectors, where each row corresponds
%         to an observation and each column corresponds to a parameter.
% muH0  - initial value of the conditional mode recursions for h margin.
% nPreH - number of initial observations to be ignored when computing the
%         empirical signal ratios for the h margin.
% Xi    - matrix of observations, where each row corresponds to an
%         observation and each column corresponds to a margin.
%
% Output:
% RSig  - matrix of posterior samples of the signal ratio, where each row
%         corresponds to an observation.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   May 31, 2017

    psiA = Theta(:, 2);
    phiA = Theta(:, 3);
    psiB = Theta(:, 10);
    phiB = Theta(:, 11);
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

    % For the a, log(b), and g margins
    rSigA = aqua_rsig_sktmar(psiA, phiA);
    rSigB = aqua_rsig_sktmar(psiB, phiB);
    rSigG = aqua_rsig_sktmar(psiG, phiG);

    % For the h margin
    nTheta = size(Theta, 1);
    rSigH = zeros(nTheta, 1);
    for i = 1:nTheta
        % Conditional mean
        muH = aqua_mu(dtaH(i), psiH(i), phiH(i), muH0, Xi(:, 4));
        w = 0.5 + 0.5 ./ (1 + exp(-gamH(i) .* (muH - ceeH(i))));
        mH = apatmean(muH, ...
            sigH(i), ...
            etaH(i), ...
            ldaH(i), ...
            iotH(i), ...
            w);

        % Empirical signal ratio
        rSigH(i) = ...
            var(mH((nPreH + 1):(end - 1))) ./ ...
            var(Xi((nPreH + 1):end, 4));
    end

    % Join the vectors
    RSig = [rSigA, rSigB, rSigG, rSigH];
end
