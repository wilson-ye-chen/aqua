function dq = dq_simnull(u, nLag, nObs, nIter)
% dq = dq_simnull(u, nLag, nObs, nIter) generates a vector of the DQ
% statistics under the null hypothesis. nObs + nLag binary observations
% are generated in each iteration as the first nLag observations are
% used to predict the first response.
%
% Input:
% u     - quantile level.
% nLag  - number of lagged hits to be included.
% nObs  - number of observations included in the regression.
% nIter - number of Monte Carlo iterations.
%
% Output:
% dq    - vector of the generated DQ statistics under null.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   October 8, 2015

    dq = zeros(nIter, 1);
    for i = 1:nIter
        h = binornd(1, u, nObs + nLag, 1);
        dq(i) = dq_stat(u, h, nLag);
    end
end
