function ...
    [DFore, Q, var1, var5, score1, score5, Beta1, Beta5, ...
    Mn, Sd, w, Theta, AccRate, Mapc, Chain] = ...
    aqua_fore_tc_v2(D, Xi, r, nEst, intEst, iStart, iEnd)
% [DFore, Q, var1, var5, score1, score5, Beta1, Beta5, Mn, Sd, w, Theta, ...
% AccRate, Mapc, Chain] = aqua_fore_tc_v2(D, Xi, r, nEst, intEst, iStart, ...
% iEnd) computes one-step-ahead Bayesian forecasts using the AQUA-gh-tc model.
%
% Input:
% D       - matrix of date-vectors.
% Xi      - matrix of observed values of a, log(b), g, and h.
% r       - vector of observed daily returns. It must contain the same number
%           of observations as Xi.
% nEst    - number of observations used to estimate the AQUA parameters.
% intEst  - number of days between two estimations.
% iStart  - starting index of the forecast period.
% iEnd    - ending index of the forecast period.
%
% Output:
% DFore   - date-vectors corresponding to the forecast period.
% Q       - intra-daily quantile forecasts.
% var1    - daily VaR forecasts at 0.01 level.
% var5    - daily VaR forecasts at 0.05 level.
% score1  - values of the scoring function for VaR-0.01.
% score5  - values of the scoring function for VaR-0.05.
% Beta1   - posterior mean of quantile regression coefficient at 0.01 level.
% Beta5   - posterior mean of quantile regression coefficient at 0.05 level.
% Mn      - conditional mean forecasts of a, log(b), g, and h.
% Sd      - conditional standard deviation forecasts for a, log(b), and g.
% w       - conditional mixing weight forecasts for h.
% Theta   - posterior mean of AQUA-gh-tc parameters.
% AccRate - block-wise acceptance rates.
% Mapc    - mean absolute percentage changes.
% Chain   - last MCMC chain.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   March 25, 2018

    % Constants
    u = [0.01, 0.05, 0.1:0.1:0.9, 0.95, 0.99];
    maxAdapt = 30;
    nIter = 105000;
    nDisc = 5000;
    nIterQreg = 52000;
    nDiscQreg = 2000;
    nDim = 40;
    nBlock = 10;

    % Allocate output arrays
    nFore = iEnd - iStart + 1;
    DFore = zeros(nFore, 3);
    Q = zeros(nFore, numel(u));
    var1 = zeros(nFore, 1);
    var5 = zeros(nFore, 1);
    score1 = zeros(nFore, 1);
    score5 = zeros(nFore, 1);
    Beta1 = zeros(nFore, 2);
    Beta5 = zeros(nFore, 2);
    Mn = zeros(nFore, 4);
    Sd = zeros(nFore, 3);
    w = zeros(nFore, 1);
    Theta = zeros(nFore, nDim);
    AccRate = zeros(nFore, nBlock);
    Mapc = zeros(nFore, maxAdapt);

    % Simulate from the AQUA posterior
    XiEst = Xi((iStart - nEst):(iStart - 1), :);
    [Chain, Accept, pc] = aqua_est_tc(XiEst, nIter, nDisc);

    % Simulate from the quantile regression posteriors
    rEst = r((iStart - nEst):(iStart - 1));
    mu0 = mean(XiEst, 1);
    QAve = aqua_aveghinv([0.01, 0.05], Chain, mu0, XiEst);
    X1 = [ones(nEst, 1), QAve(1:(end - 1), 1)];
    X5 = [ones(nEst, 1), QAve(1:(end - 1), 2)];
    ChainBeta1 = qreg_al_est(rEst, X1, 0.01, nIterQreg, nDiscQreg);
    ChainBeta5 = qreg_al_est(rEst, X5, 0.05, nIterQreg, nDiscQreg);

    % For each forecast period
    for i = 1:nFore
        % Corresponding observation index
        iObs = iStart + i - 1;

        % Record the date (sanity check)
        DFore(i, :) = D(iObs, :);

        % Forecast intra-daily quantiles
        XiFore = Xi((iObs - nEst):(iObs - 1), :);
        mu0 = mean(XiFore, 1);
        QAve = aqua_aveghinv(u, Chain, mu0, XiFore);
        Q(i, :) = QAve(end, :);

        % Forecast daily VaRs
        var1(i) = qreg_aveqtl(ChainBeta1, [1, QAve(end, 1)]);
        var5(i) = qreg_aveqtl(ChainBeta5, [1, QAve(end, 2)]);
        score1(i) = scoringfunc(r(iObs), var1(i), 0.01);
        score5(i) = scoringfunc(r(iObs), var5(i), 0.05);
        Beta1(i, :) = mean(ChainBeta1, 1);
        Beta5(i, :) = mean(ChainBeta5, 1);

        % Forecast conditional mean, standard deviation, and weight
        nSigmaSq0 = size(XiFore, 1);
        [MnAve, SdAve, wAve] = aqua_avems(Chain, mu0, nSigmaSq0, XiFore);
        Mn(i, :) = MnAve(end, :);
        Sd(i, :) = SdAve(end, :);
        w(i) = wAve(end);

        % Save posterior mean, acceptance rates, and MAPCs
        Theta(i, :) = mean(Chain, 1);
        AccRate(i, :) = sum(Accept, 1) ./ size(Accept, 1);
        Mapc(i, 1:numel(pc)) = pc;

        % Be verbose
        disp(['Forecast of ', num2str(iObs), ' is completed.']);

        % Update the posterior samples if needed
        if (mod(i, intEst) == 0) && (i ~= nFore)
            % AQUA posterior
            XiEst = Xi((iObs - nEst + 1):iObs, :);
            [Chain, Accept, pc] = aqua_est_tc(XiEst, nIter, nDisc);

            % Quantile regression posteriors
            rEst = r((iObs - nEst + 1):iObs);
            mu0 = mean(XiEst, 1);
            QAve = aqua_aveghinv([0.01, 0.05], Chain, mu0, XiEst);
            X1 = [ones(nEst, 1), QAve(1:(end - 1), 1)];
            X5 = [ones(nEst, 1), QAve(1:(end - 1), 2)];
            ChainBeta1 = qreg_al_est(rEst, X1, 0.01, nIterQreg, nDiscQreg);
            ChainBeta5 = qreg_al_est(rEst, X5, 0.05, nIterQreg, nDiscQreg);
        end
    end
end
