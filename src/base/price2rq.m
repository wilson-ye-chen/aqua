function [Rq, iDDel] = price2rq(u, p, iD, minHf)
% [Rq, iDDel] = price2rq(u, p, iD, minHf) computes daily realised quantiles
% of intra-daily returns.
%
% Input:
% u     - vector of quantile levels.
% p     - vector of intra-daily prices.
% iD    - vector of the corresponding daily indices.
% minHf - minimum number of high-frequency returns in a day.
%
% Output:
% Rq    - matrix of realised quantiles.
% iDDel - vector of daily indices of the deleted days.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   August 27, 2015

    nD = max(iD);
    Rq = zeros(nD, numel(u));
    iDKeep = false(nD, 1);
    for i = 1:nD
        iHf = (iD == i);
        if sum(iHf) > minHf
            pHf = p(iHf);
            r = diff(log(pHf)) .* 100;
            Rq(i, :) = quantile(r, u);
            iDKeep(i) = true;
        end
    end
    Rq = Rq(iDKeep, :);
    iDDel = find(~iDKeep);
end
