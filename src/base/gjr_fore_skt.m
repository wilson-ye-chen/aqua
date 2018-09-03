function ...
    [DFore, var1, var5, score1, score5, Theta, AccRate, Mapc] = ...
    gjr_fore_skt(D, r, nEst, intEst, iStart, iEnd)
% [DFore, var1, var5, score1, score5, Theta, AccRate, Mapc] = gjr_fore_skt ...
% (D, r, nEst, intEst, iStart, iEnd) computes one-step-ahead Bayesian
% forecasts using the GJR-GARCH-skewed-t model.
%
% Input:
% D       - matrix of date-vectors.
% r       - vector of observed daily returns.
% nEst    - number of observations used to estimate the parameters.
% intEst  - number of days between two estimations.
% iStart  - starting index of the forecast period.
% iEnd    - ending index of the forecast period.
%
% Output:
% DFore   - date-vectors corresponding to the forecast period.
% var1    - daily VaR forecasts at 0.01 level.
% var5    - daily VaR forecasts at 0.05 level.
% score1  - values of the scoring function for VaR-0.01.
% score5  - values of the scoring function for VaR-0.05.
% Theta   - posterior mean of GJR-skt parameters.
% AccRate - block-wise acceptance rates.
% Mapc    - mean absolute percentage changes.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   November 20, 2015

    % Constants
    u = [0.01, 0.05];
    maxAdapt = 30;
    nIter = 105000;
    nDisc = 5000;
    nDim = 7;
    nBlock = 1;
    
    % Allocate output arrays
    nFore = iEnd - iStart + 1;
    DFore = zeros(nFore, 3);
    var1 = zeros(nFore, 1);
    var5 = zeros(nFore, 1);
    score1 = zeros(nFore, 1);
    score5 = zeros(nFore, 1);
    Theta = zeros(nFore, nDim);
    AccRate = zeros(nFore, nBlock);
    Mapc = zeros(nFore, maxAdapt);
    
    % Simulate from the posterior
    rEst = r((iStart - nEst):(iStart - 1));
    [Chain, Accept, pc] = gjr_est_skt(rEst, nIter, nDisc);
    
    % For each forecast period
    for i = 1:nFore
        % Corresponding observation index
        iObs = iStart + i - 1;
        
        % Record the date (sanity check)
        DFore(i, :) = D(iObs, :);
        
        % Forecast daily VaRs
        rFore = r((iObs - nEst):(iObs - 1));
        sigmaSq0 = var(rFore);
        QAve = gjr_aveq_skt(u, Chain, rFore, sigmaSq0);
        var1(i) = QAve(end, 1);
        var5(i) = QAve(end, 2);
        score1(i) = scoringfunc(r(iObs), var1(i), 0.01);
        score5(i) = scoringfunc(r(iObs), var5(i), 0.05);
        
        % Save posterior mean, acceptance rates, and MAPCs
        Theta(i, :) = mean(Chain, 1);
        AccRate(i, :) = sum(Accept, 1) ./ size(Accept, 1);
        Mapc(i, 1:numel(pc)) = pc;
        
        % Update the posterior samples if needed
        if (mod(i, intEst) == 0) && (i ~= nFore)
            rEst = r((iObs - nEst + 1):iObs);
            [Chain, Accept, pc] = gjr_est_skt(rEst, nIter, nDisc);
        end
    end
end
