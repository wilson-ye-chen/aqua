function [rv, iDKeep] = price2rv(p, D, iD)
% [rv, iDDel, iPDel] = price2rv(p, iD, filterrule) computes daily realised
% variances using intra-daily returns. This function removes empty days.
%
% Input:
% p      - vector of intra-daily prices.
% D      - matrix of date-vectors.
% iD     - vector of row indices of the D matrix.
%
% Output:
% rv     - vector of realised variances.
% iDKeep - binary vector where a zero indicates a removed day.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   June 11, 2017

    nD = size(D, 1);
    nP = numel(p);
    rv = zeros(nD, 1);
    iDKeep = false(nD, 1);
    for i = 1:nD
        iP = find(iD == i);
        pD = p(iP);
        if ~isempty(pD)
            r = diff(log(pD)) .* 100;
            rv(i) = sum(r .^ 2);
            iDKeep(i) = true;
        end
    end
    rv = rv(iDKeep);
end
