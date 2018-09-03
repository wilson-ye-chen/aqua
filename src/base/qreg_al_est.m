function [Theta, Accept, mapc, ThetaAd, Scale] = qreg_al_est( ...
    y, X, u, nIter, nDiscard)
% [Theta, Accept, mapc, ThetaAd, Scale] = qreg_al_est(y, X, u, nIter, ...
% nDiscard) implements a Gibbs sampling scheme to generate samples from the
% posterior of a quantile regression model, where the likelihood is asymmetric
% Laplace and the prior is proportional to one over the scale parameter of the
% ALD. The scale parameter is integrated out of the posterior.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   September 21, 2015

    % Log-posterior
    kernel = @(theta)qreg_al_post(theta, y, X, u);
    
    % Initial parameter values
    nDim = size(X, 2);
    theta0 = zeros(1, nDim);
    
    % Define parameter blocking
    block{1} = 1:nDim;
    
    % Block dependent configuration
    SigProp0{1} = eye(nDim);
    scale0 = 2.38 ./ sqrt(nDim);
    targAcc = targaccrate(nDim);
    accTol = 0.075;
    
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
    SigProp{1} = (aveScl .^ 2) .* SigProp{1};
    [Theta, Accept] = gmrwmetrop( ...
        kernel, theta0, block, SigProp, w, s, nIter);
    
    % Discard a few initial samples
    Theta = Theta((nDiscard + 1):end, :);
    Accept = Accept((nDiscard + 1):end, :);
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
