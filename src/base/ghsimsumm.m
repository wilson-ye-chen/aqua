function T = ghsimsumm(tv, result)
% T = ghsimsumm(tv, result) computes summaries from a simulation study
% on various estimators of g-and-h parameters, and organises them into
% a 14-by-4 table stored as a matrix. The table is organised as below:
%
% -----------------------------------
%             | MoM | ML | QM | MoLM
% -----------------------------------
%    a | Mean |
%      |   SD |
%      |  MSE |
% -----------------------------------
%    b | Mean |
%      |   SD |
%      |  MSE |
% -----------------------------------
%    g | Mean |
%      |   SD |
%      |  MSE |
% -----------------------------------
%    h | Mean |
%      |   SD |
%      |  MSE |
% -----------------------------------
%  tmr | Mean |
%  tmr |   SD |
% -----------------------------------
%
% Inputs:
% tv     - vector of true values of the g-and-h parameters.
% result - result structure from a simulation study.
%
% Outputs:
% T      - table containing summaries as a 14-by-4 matrix.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   April 8, 2015

    T = zeros(14, 4);
    
    % Moment matching
    Gh = result.mom.Gh;
    timer = result.mom.timer;
    n = size(Gh, 1);
    mn = mean(Gh, 1);
    sd = std(Gh, 1);
    mse = mean((Gh - repmat(tv, n, 1)) .^ 2);
    T([1, 4, 7, 10], 1) = mn;
    T([2, 5, 8, 11], 1) = sd;
    T([3, 6, 9, 12], 1) = mse;
    T(13, 1) = mean(timer);
    T(14, 1) = std(timer);
    
    % Maximum likelihood
    Gh = result.ml.Gh;
    timer = result.ml.timer;
    n = size(Gh, 1);
    mn = mean(Gh, 1);
    sd = std(Gh, 1);
    mse = mean((Gh - repmat(tv, n, 1)) .^ 2);
    T([1, 4, 7, 10], 2) = mn;
    T([2, 5, 8, 11], 2) = sd;
    T([3, 6, 9, 12], 2) = mse;
    T(13, 2) = mean(timer);
    T(14, 2) = std(timer);
    
    % Quantile matching
    Gh = result.qm.Gh;
    timer = result.qm.timer;
    n = size(Gh, 1);
    mn = mean(Gh, 1);
    sd = std(Gh, 1);
    mse = mean((Gh - repmat(tv, n, 1)) .^ 2);
    T([1, 4, 7, 10], 3) = mn;
    T([2, 5, 8, 11], 3) = sd;
    T([3, 6, 9, 12], 3) = mse;
    T(13, 3) = mean(timer);
    T(14, 3) = std(timer);
    
    % Method of L-moments
    Gh = result.lmom.Gh;
    timer = result.lmom.timer;
    n = size(Gh, 1);
    mn = mean(Gh, 1);
    sd = std(Gh, 1);
    mse = mean((Gh - repmat(tv, n, 1)) .^ 2);
    T([1, 4, 7, 10], 4) = mn;
    T([2, 5, 8, 11], 4) = sd;
    T([3, 6, 9, 12], 4) = mse;
    T(13, 4) = mean(timer);
    T(14, 4) = std(timer);
end
