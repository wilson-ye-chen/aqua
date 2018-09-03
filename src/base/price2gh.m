function [Gh, fVal, flag, iDKeep] = price2gh(p, D, iD)
% [Gh, fVal, flag, iDKeep] = price2gh(p, D, iD) fits the g-and-h distribution
% to intra-daily returns, using a numerical method of L-moments. This function
% removes empty days.
%
% Input:
% p      - vector of intra-daily prices.
% D      - matrix of date-vectors.
% iD     - vector of row indices of the D matrix.
%
% Output:
% Gh     - matrix of fitted g-and-h parameters.
% fVal   - vector of L2-distances between L-moment ratios.
% flag   - vector of exit flags of the optimisation routine.
% iDKeep - binary vector where a zero indicates a removed day.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   June 11, 2017

    nD = size(D, 1);
    nP = numel(p);
    Gh = zeros(nD, 4);
    fVal = zeros(nD, 1);
    flag = zeros(nD, 1);
    iDKeep = false(nD, 1);
    for i = 1:nD
        iP = find(iD == i);
        pD = p(iP);
        if ~isempty(pD)
            r = diff(log(pD)) .* 100;
            [Gh(i, :), fVal(i), flag(i)] = ghfit_lmom(r);
            iDKeep(i) = true;
        end
    end
    Gh = Gh(iDKeep, :);
    fVal = fVal(iDKeep);
    flag = flag(iDKeep);
end
