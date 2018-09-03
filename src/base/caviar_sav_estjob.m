function caviar_sav_estjob(dataFile, outFile)
% caviar_sav_estjob(dataFile, outFile) is the top-level function for running
% the in-sample part of the empirical study of the CAViaR-SAV model.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   June 11, 2017

    load(dataFile);
    rng('shuffle', 'twister');
    rngState = rng();

    % Simulate from CAViaR-SAV posteriors
    Chain1 = caviar_sav_est(r, 0.01, 105000, 5000);
    Chain5 = caviar_sav_est(r, 0.05, 105000, 5000);

    % Daily VaR estimates
    q0 = quantile(r, [0.01, 0.05]);
    var1 = caviar_sav_aveq(Chain1, r, q0(1));
    var5 = caviar_sav_aveq(Chain5, r, q0(2));
    var1 = var1(1:(end - 1));
    var5 = var5(1:(end - 1));

    % Simple scores for daily VaR estimates
    score1 = scoringfunc(r, var1, 0.01);
    score5 = scoringfunc(r, var5, 0.05);

    % Save results
    save(outFile, ...
        'rngState', ...
        'D', 'r', ...
        'Chain1', 'Chain5', 'var1', 'var5', 'score1', 'score5');
end
