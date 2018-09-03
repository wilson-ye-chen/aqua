function [Theta, Accept, mapc, ThetaAd, Scale] = aqua_est_gc( ...
    Xi, nIter, nDiscard)
% [Theta, Accept, mapc, ThetaAd, Scale] = aqua_est_gc(Xi, nIter, nDiscard)
% implements a Gibbs sampling scheme to generate samples from the posterior
% of the gh-AQUA model, where the dependencies are modelled using a Gaussian
% copula, the conditional marginal distributions of a, log(b), and g are
% skewed-t, and those of h are Apatosaurus.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   February 14, 2016

    % Log-posterior
    mu0 = mean(Xi, 1);
    nPre = 50;
    nSigmaSq0 = size(Xi, 1);
    kernel = @(theta)aqua_like_gc( ...
        theta(1:8), ...
        theta(9:16), ...
        theta(17:24), ...
        theta(25:33), ...
        theta(34:39), ...
        mu0, nSigmaSq0, nPre, Xi) + ...
        prior(theta);
    
    % Initial parameter values
    a0 = [0, 0.1, 0.8, 0.01, 0.1, 0.8, 8, 0];
    b0 = [0, 0.1, 0.8, 0.01, 0.1, 0.8, 8, 0];
    g0 = [0, 0.1, 0.8, 0.01, 0.1, 0.8, 8, 0];
    h0 = [0.1, 0.1, 0.8, 0, 30, 0.1, 8, 0, 0.001];
    c0 = nonzeros(tril(corr(Xi), -1))';
    theta0 = [a0, b0, g0, h0, c0];
    
    % Define parameter blocking
    block = cell(9, 1);
    block{1} = 1:3;
    block{2} = 4:8;
    block{3} = 9:11;
    block{4} = 12:16;
    block{5} = 17:19;
    block{6} = 20:24;
    block{7} = 25:29;
    block{8} = 30:33;
    block{9} = 34:39;
    
    % Block dependent configuration
    SigProp0 = cell(9, 1);
    scale0 = zeros(9, 1);
    targAcc = zeros(9, 1);
    accTol = zeros(9, 1);
    for i = 1:9
        nDim = numel(block{i});
        SigProp0{i} = eye(nDim);
        scale0(i) = 2.38 ./ sqrt(nDim);
        targAcc(i) = targaccrate(nDim);
        accTol(i) = 0.075;
    end
    
    % Global configuration
    w = [0.7, 0.15, 0.15];
    s = [1, 100, 0.01];
    nTune = 200;
    nIterAd = 12000;
    nDiscardAd = 2000;
    minAdapt = 2;
    maxAdapt = 30;
    mapcTol = 0.1;
    
    % Run the adaptive random-walk Metropolis sampler
    [ThetaAd, Scale, SigProp, Accept, mapc] = gmrwmetropadapt( ...
        kernel, theta0, block, scale0, SigProp0, w, s, ...
        targAcc, accTol, nTune, nIterAd, nDiscardAd, ...
        minAdapt, maxAdapt, mapcTol);
    
    % Stop adapting after tuning period
    theta0 = mean(ThetaAd, 1);
    aveScl = mean(Scale, 1);
    for i = 1:9
        SigProp{i} = (aveScl(i) .^ 2) .* SigProp{i};
    end
    [Theta, Accept] = gmrwmetrop( ...
        kernel, theta0, block, SigProp, w, s, nIter);
    
    % Discard a few initial samples
    Theta = Theta((nDiscard + 1):end, :);
    Accept = Accept((nDiscard + 1):end, :);
end

function logPrr = prior(theta)
    eta = theta([7, 15, 23, 31]);
    iota = theta(33);
    logPrr = -2 .* sum(log(eta)) - log(1 + (iota ./ 1e-5) .^ 2);
end

function accRate = targaccrate(nDim)
    if nDim == 1
        accRate = 0.44;
    elseif nDim >= 2 && nDim <= 4
        accRate = 0.35;
    else
        accRate = 0.234;
    end
end
