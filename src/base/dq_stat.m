function dq = dq_stat(u, h, nLag)
% dq = dq_stat(u, h, nLag) computes the test statisitic of the Dynamic
% Quantile (DQ) test of Engle and Manganelli (2004). The DQ statistic follows
% asymptotically a chi-squared distribution with nLag + 1 degrees of freedom.
% The first nLag observations of the hit vector h are dropped when computing
% the response vector.
%
% Input:
% u    - quantile level.
% h    - binary vector of hits.
% nLag - number of lagged hits to be included.
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
    X = [o, W];
    % Response vector
    y = z((nLag + 1):end);
    % DQ statistic
    b = X \ y;
    dq = b' * (X' * X) * b ./ (u .* (1 - u));
end
