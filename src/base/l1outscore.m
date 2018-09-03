function score = l1outscore(p, st, ss)
% score = l1outscore(p, st, ss) computes the outlier score of each
% observation in p, based on L1-splines of Tepper and Sapiro (2012).
%
% Input:
% p     - vector of prices.
% st    - smoothing parameter for trend, e.g., 50.
% ss    - smoothing parameter for scale, e.g., 50,000.
%
% Output:
% score - vector of outlier scores.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   June 19, 2016

    t = l1spline(p, st, 1, 5000, 1, 1e-5);
    e = p - t;
    s = l1spline(log(abs(e)), ss, 1, 5000, 1, 1e-5);
    z = e ./ exp(s);
    score = abs((z - median(z)) ./ iqr(z));
end
