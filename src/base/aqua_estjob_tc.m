function aqua_estjob_tc(dataFile, outFile)
% aqua_estjob_tc(dataFile, outFile) is the top-level function for running
% the in-sample part of the empirical study of the AQUA-gh-tc model.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   May 29, 2017

    load(dataFile);
    rng('shuffle', 'twister');
    rngState = rng();

    % Simulate from AQUA posterior
    Theta = aqua_est_tc(Xi, 105000, 5000);

    % Conditional mean and weight estimates
    mu0 = mean(Xi, 1);
    nSigmaSq0 = size(Xi, 1);
    [MAve, ~, wAve] = aqua_avems(Theta, mu0, nSigmaSq0, Xi);
    MAve = MAve(1:(end - 1), :);
    wAve = wAve(1:(end - 1));

    % Posterior draws of the signal ratio for each margin
    RSig = aqua_rsig(Theta, mu0(4), 50, Xi);

    % Intra-daily VaR estimates
    u = [0.01, 0.05, 0.1:0.1:0.9, 0.95, 0.99];
    QAve = aqua_aveghinv(u, Theta, mu0, Xi);
    QAve = QAve(1:(end - 1), :);

    % Simulate from quantile regression posteriors
    chainS1 = qreg_al_est(r, QAve(:, 1), 0.01, 52000, 2000);
    chainS5 = qreg_al_est(r, QAve(:, 2), 0.05, 52000, 2000);

    % Daily VaR estimates
    var1 = qreg_aveqtl(chainS1, QAve(:, 1));
    var5 = qreg_aveqtl(chainS5, QAve(:, 2));

    % Simple scores for daily VaR estimates
    score1 = scoringfunc(r, var1, 0.01);
    score5 = scoringfunc(r, var5, 0.05);

    % Save results
    save(outFile, ...
        'rngState', ...
        'D', 'Xi', 'r', ...
        'Theta', 'MAve', 'wAve', 'RSig', 'u', 'QAve', ...
        'chainS1', 'chainS5', 'var1', 'var5', 'score1', 'score5');
end
