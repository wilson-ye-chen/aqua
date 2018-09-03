function [qf, qx, u] = myqqplot(f, x)
% [qf, qx, u] = myqqplot(f, x) constructs a qq-plot (without drawing the
% plot) using an user defined quantile function. The method used to compute
% the quantile levels is: u = (k - 0.5) / n for k in {1, ..., n}.
%
% Input:
% f  - handle to a quantile function f(u) where u is a row vector.
% x  - vector of observations.
%
% Output:
% qf - vector of population quantiles.
% qx - vector of sample quantiles.
% u  - row vector of quantile levels used.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   April 10, 2016

    n = numel(x);
    u = ([1:n] - 0.5) ./ n;
    qf = f(u);
    qx = sort(x, 'ascend');
    qf = qf(:);
    qx = qx(:);
end
