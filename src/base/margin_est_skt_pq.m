function [Theta, Accept, mapc, ThetaAd, Scale] = margin_est_skt_pq( ...
    a, k, xi, nIter, nDiscard)
% [Theta, Accept, mapc, ThetaAd, Scale] = margin_est_skt_pq(a, k, xi, ...
% nIter, nDiscard) implements an adaptive MCMC sampling algorithm for
% simulating from the posterior distribution of the ARMA(1,1)-GARCH(1,1)-Skt
% model, where a Power Quotient (PQ) prior is placed on the Signal Ratio.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   April 27, 2016

    % Log-posterior
    mu0 = mean(xi);
    nSigmaSq0 = numel(xi);
    nPre = 50;
    kernel = @(theta)aqua_like_sktmar( ...
        theta(1), theta(2), theta(3), ...
        theta(4), theta(5), theta(6), ...
        theta(7), theta(8), ...
        mu0, nSigmaSq0, nPre, xi) + ...
        prior(theta, a, k);
    
    % Initial parameter values
    theta0 = [0, 0.1, 0.8, 0.01, 0.1, 0.8, 8, 0];
    
    % Define parameter blocking
    block{1} = 1:3;
    block{2} = 4:8;
    
    % Block dependent configuration
    SigProp0 = cell(2, 1);
    scale0 = zeros(2, 1);
    targAcc = zeros(2, 1);
    accTol = zeros(2, 1);
    for i = 1:2
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
    
    % Block-wise random-walk Metropolis sampler
    theta0 = mean(ThetaAd, 1);
    aveScale = mean(Scale, 1);
    for i = 1:2
        SigProp{i} = (aveScale(i) .^ 2) .* SigProp{i};
    end
    [Theta, Accept] = gmrwmetrop( ...
        kernel, theta0, block, SigProp, w, s, nIter);
    
    % Discard a few initial samples
    Theta = Theta((nDiscard + 1):end, :);
    Accept = Accept((nDiscard + 1):end, :);
end

function logPrr = prior(theta, a, k)
    psi = theta(2);
    phi = theta(3);
    eta = theta(7);
    rSig = aqua_rsig_sktmar(psi, phi);
    logPrr = -2 .* log(eta) + pq(rSig, a, k);
end

function y = pq(x, a, k)
    y = k .* log(x) - log(a + x .^ k);
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
