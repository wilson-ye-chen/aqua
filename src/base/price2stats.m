function [nObs, nGap, maxC, nOut, maxS] = price2stats(p, iD, cTol, sTol)
% [nObs, nGap, maxC, nOut, maxS] = price2stats(p, iD, cTol, sTol) computes
% various statistics of intra-daily prices. This function is useful for
% building rules for data cleaning.
%
% Input:
% p    - vector of intra-daily prices.
% iD   - vector of the corresponding daily indices.
% cTol - gap tolerance in minutes, e.g., 30.
% sTol - outlier score tolerance, e.g., 20.
%
% Output:
% nObs - number of observations per day.
% nGap - number of gaps with sizes greater than or equal to cTol.
% maxC - daily maximum of the number of consecutive equal prices.
% nOut - number of outliers with scores greater than or equal to sTol.
% maxS - daily maximum of outlier scores.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   June 6, 2016

    nD = max(iD);
    nObs = zeros(nD, 1);
    nGap = zeros(nD, 1);
    maxC = zeros(nD, 1);
    nOut = zeros(nD, 1);
    maxS = zeros(nD, 1);
    for i = 1:nD
        iP = (iD == i);
        pD = p(iP);
        r = diff(log(pD));
        c = consec(r == 0);
        nObs(i) = numel(pD);
        nGap(i) = sum(c >= cTol);
        if isempty(c)
            maxC(i) = 0;
        else
            maxC(i) = max(c);
        end
        if nObs(i) < 60 || maxC(i) >= cTol
            nOut(i) = nan;
            maxS(i) = nan;
        else
            score = outscore(pD);
            nOut(i) = sum(score >= sTol);
            maxS(i) = max(score);
        end
    end
end

function score = outscore(p)
    st = 50;
    ss = 50000;
    t = l1spline(p, st, 1, 5000, 1, 1e-5);
    e = p - t;
    s = l1spline(log(abs(e)), ss, 1, 5000, 1, 1e-5);
    z = e ./ exp(s);
    score = abs((z - median(z)) ./ iqr(z));
end
