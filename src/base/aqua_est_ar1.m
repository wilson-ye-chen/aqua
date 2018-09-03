function [Theta, Accept, mapc, ThetaAd, Scale] = aqua_est_ar1( ...
    Xi, nIter, nDiscard)
% [Theta, Accept, mapc, ThetaAd, Scale] = aqua_est_ar1(Xi, nIter, nDiscard)
% implements a margin-by-margin sampling scheme to generate samples from the
% posterior of the gh-AQUA model, where each margin follows a Gaussian-AR(1)
% process, and the margins are independent.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   May 2, 2018

    Theta = [];
    Accept = [];
    mapc = [];
    ThetaAd = [];
    Scale = [];
    for i = 1:4
        [Tht, acc, pc, ThtAd, scl] = margin_est_ar1( ...
            Xi(:, i), nIter, nDiscard);
        Theta = [Theta, Tht];
        Accept = [Accept, acc];
        mapc = [mapc; pc];
        ThetaAd = [ThetaAd, ThtAd];
        Scale = [Scale, scl];
    end
end
