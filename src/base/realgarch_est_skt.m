function [Theta, Accept, mapc, ThetaAd, Scale] = realgarch_est_skt( ...
    r, logX, nIter, nDiscard)
% [Theta, Accept, mapc, ThetaAd, Scale] = realgarch_est_skt(r, logX, ...
% nIter, nDiscard) implements a Gibbs sampling scheme to generate samples
% from the posterior of the Realised-GARCH-skt model. The prior is flat over
% most of the allowable parameter space with the exception of the degrees-of-
% freedom parameter of the skewed-t distribution, where it is proportional to
% one over the squared DoF.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   October 2, 2015

    % Log-posterior
    nPre = 50;
    logSigmaSq0 = log(var(r));
    kernel = @(theta)realgarch_like_skt( ...
        theta(1), theta(2), theta(3), theta(4), theta(5), theta(6), ...
        theta(7), theta(8), theta(9), theta(10), theta(11), ...
        logSigmaSq0, nPre, r, logX) + ...
        prior(theta);
    
    % Initial parameter values
    theta0 = [ ...
        0, 0.1, 0.7, 0.2, 8, 0, ...
        -0.3, 1, 0, 0.1, 0.5];
    
    % Define parameter blocking
    block = cell(2, 1);
    block{1} = 1:6;
    block{2} = 7:11;
    
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
    
    % Stop adapting after tuning period
    theta0 = mean(ThetaAd, 1);
    aveScl = mean(Scale, 1);
    for i = 1:2
        SigProp{i} = (aveScl(i) .^ 2) .* SigProp{i};
    end
    [Theta, Accept] = gmrwmetrop( ...
        kernel, theta0, block, SigProp, w, s, nIter);
    
    % Discard a few initial samples
    Theta = Theta((nDiscard + 1):end, :);
    Accept = Accept((nDiscard + 1):end, :);
end

function logPrr = prior(theta)
    df = theta(5);
    logPrr = -2 .* sum(log(df));
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
