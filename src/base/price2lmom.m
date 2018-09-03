function [Lt, iDDel] = price2lmom(p, iD, minHf)
% [Lt, iDDel] = price2lmom(p, iD, minHf) converts intra-daily prices
% to the sample L-moments and L-moment ratios of intra-daily returns.
%
% Input:
% p     - vector of intra-daily prices.
% iD    - vector of the corresponding daily indices.
% minHf - minimum number of high-frequency returns in a day.
%
% Output:
% Lt    - matrix of sample L-moments and L-moment ratios of intra-
%         daily returns.
% iDDel - vector of daily indices of the deleted days.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   October 25, 2014

    nD = max(iD);
    L = zeros(nD, 4);
    iDKeep = false(nD, 1);
    for i = 1:nD
        iHf = (iD == i);
        if sum(iHf) > minHf
            pHf = p(iHf);
            r = diff(log(pHf)) .* 100;
            L(i, :) = lmom(r);
            iDKeep(i) = true;
        end
    end
    l1 = L(iDKeep, 1);
    l2 = L(iDKeep, 2);
    t3 = L(iDKeep, 3) ./ l2;
    t4 = L(iDKeep, 4) ./ l2;
    Lt = [l1, l2, t3, t4];
    iDDel = find(~iDKeep);
end
