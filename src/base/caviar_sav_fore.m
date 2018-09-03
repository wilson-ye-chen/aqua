function ...
    [DFore, var1, var5, score1, score5, ...
    Theta1, Theta5, AccRate1, AccRate5, Mapc1, Mapc5] = ...
    caviar_sav_fore(D, r, nEst, intEst, iStart, iEnd)
% [DFore, var1, var5, score1, score5, Theta1, Theta5, AccRate1, AccRate5, ...
% Mapc1, Mapc5] = caviar_sav_fore(D, r, nEst, intEst, iStart, iEnd) computes
% one-step-ahead Bayesian forecasts using the CAViaR-SAV model.
%
% Input:
% D        - matrix of date-vectors.
% r        - vector of observed daily returns.
% nEst     - number of observations used to estimate the parameters.
% intEst   - number of days between two estimations.
% iStart   - starting index of the forecast period.
% iEnd     - ending index of the forecast period.
%
% Output:
% DFore    - date-vectors corresponding to the forecast period.
% var1     - daily VaR forecasts at 0.01 level.
% var5     - daily VaR forecasts at 0.05 level.
% score1   - values of the scoring function for VaR-0.01.
% score5   - values of the scoring function for VaR-0.05.
% Theta1   - posterior mean of CAViaR-SAV parameters for VaR-0.01.
% Theta5   - posterior mean of CAViaR-SAV parameters for VaR-0.05.
% AccRate1 - block-wise acceptance rates for VaR-0.01.
% AccRate5 - block-wise acceptance rates for VaR-0.05.
% Mapc1    - mean absolute percentage changes for VaR-0.01.
% Mapc5    - mean absolute percentate changes for VaR-0.05.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   November 20, 2015

    % Constants
    maxAdapt = 30;
    nIter = 105000;
    nDisc = 5000;
    nDim = 3;
    nBlock = 1;
    
    % Allocate output arrays
    nFore = iEnd - iStart + 1;
    DFore = zeros(nFore, 3);
    var1 = zeros(nFore, 1);
    var5 = zeros(nFore, 1);
    score1 = zeros(nFore, 1);
    score5 = zeros(nFore, 1);
    Theta1 = zeros(nFore, nDim);
    Theta5 = zeros(nFore, nDim);
    AccRate1 = zeros(nFore, nBlock);
    AccRate5 = zeros(nFore, nBlock);
    Mapc1 = zeros(nFore, maxAdapt);
    Mapc5 = zeros(nFore, maxAdapt);
    
    % Simulate from the posterior
    rEst = r((iStart - nEst):(iStart - 1));
    [Chain1, Accept1, pc1] = caviar_sav_est(rEst, 0.01, nIter, nDisc);
    [Chain5, Accept5, pc5] = caviar_sav_est(rEst, 0.05, nIter, nDisc);
    
    % For each forecast period
    for i = 1:nFore
        % Corresponding observation index
        iObs = iStart + i - 1;
        
        % Record the date (sanity check)
        DFore(i, :) = D(iObs, :);
        
        % Forecast daily VaRs
        rFore = r((iObs - nEst):(iObs - 1));
        q0 = quantile(rFore, [0.01, 0.05]);
        qAve1 = caviar_sav_aveq(Chain1, rFore, q0(1));
        qAve5 = caviar_sav_aveq(Chain5, rFore, q0(2));
        var1(i) = qAve1(end);
        var5(i) = qAve5(end);
        score1(i) = scoringfunc(r(iObs), var1(i), 0.01);
        score5(i) = scoringfunc(r(iObs), var5(i), 0.05);
        
        % Save posterior mean, acceptance rates, and MAPCs
        Theta1(i, :) = mean(Chain1, 1);
        Theta5(i, :) = mean(Chain5, 1);
        AccRate1(i, :) = sum(Accept1, 1) ./ size(Accept1, 1);
        AccRate5(i, :) = sum(Accept5, 1) ./ size(Accept5, 1);
        Mapc1(i, 1:numel(pc1)) = pc1;
        Mapc5(i, 1:numel(pc5)) = pc5;
        
        % Update the posterior samples if needed
        if (mod(i, intEst) == 0) && (i ~= nFore)
            rEst = r((iObs - nEst + 1):iObs);
            [Chain1, Accept1, pc1] = caviar_sav_est(rEst, 0.01, nIter, nDisc);
            [Chain5, Accept5, pc5] = caviar_sav_est(rEst, 0.05, nIter, nDisc);
        end
    end
end
