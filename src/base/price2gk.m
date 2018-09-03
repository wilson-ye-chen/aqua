function [Gk, fVal, flag, iDDel] = price2gk(p, iD, minHf, c)
% [Gk, fVal, flag, iDDel] = price2gk(p, iD, minHf, c) fits the
% g-and-k distribution to intra-daily returns, using a numerical
% method of L-moments.
%
% Input:
% p     - vector of intra-daily prices.
% iD    - vector of the corresponding daily indices.
% minHf - minimum number of high-frequency returns in a day.
% c     - overall asymmetry parameter, typically set to 0.8.
%
% Output:
% Gk    - matrix of fitted g-and-k parameters.
% fVal  - vector of L2-distances between L-moment ratios.
% flag  - vector of exit flags of the optimisation routine.
% iDDel - vector of daily indices of the deleted days.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   May 3, 2016

    nD = max(iD);
    Gk = zeros(nD, 4);
    fVal = zeros(nD, 1);
    flag = zeros(nD, 1);
    iDKeep = false(nD, 1);
    for i = 1:nD
        iHf = (iD == i);
        if sum(iHf) > minHf
            pHf = p(iHf);
            r = diff(log(pHf)) .* 100;
            [Gk(i, :), fVal(i), flag(i)] = gkfit_lmom(r, c);
            iDKeep(i) = true;
        end
    end
    Gk = Gk(iDKeep, :);
    fVal = fVal(iDKeep);
    flag = flag(iDKeep);
    iDDel = find(~iDKeep);
end
