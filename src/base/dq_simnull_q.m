function dq = dq_simnull_q(u, nLag, q, nIter)
% dq = dq_simnull_q(u, nLag, q, nIter) generates a vector of the DQ
% statistics under the null hypothesis. The first nLag observations
% of the predicted quantiles q are dropped when computing the design
% matrix.
%
% Input:
% u     - quantile level.
% nLag  - number of lagged hits to be included.
% q     - vector of predicted contemporaneous u-level quantiles.
% nIter - number of Monte Carlo iterations.
%
% Output:
% dq    - vector of the generated DQ statistics under null.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   October 8, 2015

    nObs = numel(q);
    dq = zeros(nIter, 1);
    for i = 1:nIter
        h = binornd(1, u, nObs, 1);
        dq(i) = dq_stat_q(u, h, nLag, q);
    end
end
