function run_scaling_sim(p, nMin, simData)
% run_scaling_sim(p, nMin, simData) runs a simulation study of quantile
% scaling via Bayesian quantile regression.
%
% Input:
% p       - quantile level.
% nMin    - number of 1-minute returns in a day.
% simData - simulated data file storing simulated Xi.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   March 21, 2018

    % Set random number generator
    rng('shuffle', 'twister');
    rngState = rng();

    % Load simulated data for Xi
    load(simData);
    [nObs, ~, nRep] = size(Xi);

    % g-and-h parameters
    Gh = [Xi(:, 1, :), exp(Xi(:, 2, :)), Xi(:, 3, :), Xi(:, 4, :)];

    % Output variables
    R = zeros(nObs, nRep);
    Qtl = zeros(nObs, nRep);
    Beta = zeros(nRep, 2);

    % For each repetition
    for i = 1:nRep
        % Simulate daily observations
        U = unifrnd(0, 1, nObs, nMin);
        R(:, i) = sum(ghinv(U, Gh(:, :, i)), 2);

        % Compute 1-miniute quantiles
        q = ghinv(repmat(p, nObs, 1), Gh(:, :, i));

        % Estimate the scaling factor
        X = [ones(nObs, 1), q];
        Chain = qreg_al_est(R(:, i), X, p, 52000, 2000);
        Qtl(:, i) = qreg_aveqtl(Chain, X);
        Beta(i, :) = mean(Chain, 1);
    end

    % Hit rates
    hr = sum(R < Qtl, 1) ./ nObs;

    % Save outputs
    name = sprintf('simresult_scaling_%d.mat', p .* 100);
    save(name, 'rngState', 'R', 'Qtl', 'Beta', 'hr');
end
