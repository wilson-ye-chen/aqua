function dq = dq_stat_q(u, h, nLag, q)
% dq = dq_stat_q(u, h, nLag, q) computes the test statisitic of the Dynamic
% Quantile (DQ) test of Engle and Manganelli (2004). The DQ statistic follows
% asymptotically a chi-squared distribution with nLag + 2 degrees of freedom.
% The first nLag observations of the hit vector h are dropped when computing
% the response vector. Similarly the first nLag observations of the predicted
% quantiles q are also dropped when computing the design matrix.
%
% Input:
% u    - quantile level.
% h    - binary vector of hits.
% nLag - number of lagged hits to be included.
% q    - vector of predicted contemporaneous u-level quantiles.
%
% Output:
% dq   - value of the test statistic.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   October 9, 2015

    % Vector of centred hits
    z = h - u;
    % Design matrix
    o = ones(numel(h) - nLag, 1);
    W = roll(z, nLag);
    W = W(1:(end - 1), :);
    q = q((nLag + 1):end);
    X = [o, W, q];
    % Response vector
    y = z((nLag + 1):end);
    % DQ statistic
    b = X \ y;
    dq = b' * (X' * X) * b ./ (u .* (1 - u));
end
