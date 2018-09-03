function [Theta, Accept, mapc, ThetaAd, Scale] = margin_est_ar1( ...
    xi, nIter, nDiscard)
% [Theta, Accept, mapc, ThetaAd, Scale] = margin_est_ar1(xi, nIter, nDiscard)
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   May 2, 2018

    % Log-posterior
    nPre = 50;
    mu0 = mean(xi);
    kernel = @(theta)aqua_like_ar1mar( ...
        theta(1), theta(2), theta(3), mu0, nPre, xi) + ...
        prior(theta);

    % Initial parameter values
    theta0 = [0, 0.5, std(xi)];

    % Define parameter blocking
    block{1} = 1:3;

    % Block dependent configuration
    nBlk = numel(block);
    SigProp0 = cell(nBlk, 1);
    scale0 = zeros(nBlk, 1);
    targAcc = zeros(nBlk, 1);
    accTol = zeros(nBlk, 1);
    for i = 1:nBlk
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
    for i = 1:nBlk
        SigProp{i} = (aveScale(i) .^ 2) .* SigProp{i};
    end
    [Theta, Accept] = gmrwmetrop( ...
        kernel, theta0, block, SigProp, w, s, nIter);

    % Discard a few initial samples
    Theta = Theta((nDiscard + 1):end, :);
    Accept = Accept((nDiscard + 1):end, :);
end

function logPrr = prior(theta)
    sigma = theta(3);
    logPrr = -sigma;
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
