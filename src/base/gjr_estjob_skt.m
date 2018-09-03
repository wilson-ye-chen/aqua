function gjr_estjob_skt(dataFile, outFile)
% gjr_estjob_skt(dataFile, outFile) is the top-level function for running
% the in-sample part of the empirical study of the GJR-GARCH-skt model.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   June 11, 2017

    load(dataFile);
    rng('shuffle', 'twister');
    rngState = rng();

    % Simulate from GJR-skt posteriors
    Chain = gjr_est_skt(r, 105000, 5000);

    % Daily VaR estimates
    sigmaSq0 = var(r);
    QAve = gjr_aveq_skt([0.01, 0.05], Chain, r, sigmaSq0);
    var1 = QAve(1:(end - 1), 1);
    var5 = QAve(1:(end - 1), 2);

    % Simple scores for daily VaR estimates
    score1 = scoringfunc(r, var1, 0.01);
    score5 = scoringfunc(r, var5, 0.05);

    % Save results
    save(outFile, ...
        'rngState', ...
        'D', 'r', ...
        'Chain', 'var1', 'var5', 'score1', 'score5');
end
