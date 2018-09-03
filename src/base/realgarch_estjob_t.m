function realgarch_estjob_t(dataFile, outFile)
% realgarch_estjob_t(dataFile, outFile) is the top-level function for running
% the in-sample part of the empirical study of the Realised-GARCH-t model.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   June 11, 2017

    load(dataFile);
    rng('shuffle', 'twister');
    rngState = rng();

    % Simulate from Realised-GARCH-t posteriors
    Chain = realgarch_est_t(r, logX, 105000, 5000);

    % Daily VaR estimates
    logSigmaSq0 = log(var(r));
    QAve = realgarch_aveq_t([0.01, 0.05], Chain, logX, logSigmaSq0);
    var1 = QAve(1:(end - 1), 1);
    var5 = QAve(1:(end - 1), 2);

    % Simple scores for daily VaR estimates
    score1 = scoringfunc(r, var1, 0.01);
    score5 = scoringfunc(r, var5, 0.05);

    % Save results
    save(outFile, ...
        'rngState', ...
        'D', 'logX', 'r', ...
        'Chain', 'var1', 'var5', 'score1', 'score5');
end
