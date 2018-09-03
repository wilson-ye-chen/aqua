function score = l1outlier(y, st, ss, tol)
% score = l1outlier(y, st, ss, tol) finds outliers in a generic
% time series. The L1 spline of Tepper and Sapiro (2012) are used
% to robustly estimate the dynamic trend the scale of the series.
%
% Input:
% y     - vector of observations.
% st    - smoothing parameter for trend, e.g., 50.
% ss    - smoothing parameter for scale, e.g., 50,000.
% tol   - decision tolerance of the outlier score, e.g., 20.
%
% Output:
% score - vector of outlier scores.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   June 16, 2016

    t = l1spline(y, st, 1, 5000, 1, 1e-5);
    e = y - t;
    s = l1spline(log(abs(e)), ss, 1, 5000, 1, 1e-5);
    z = e ./ exp(s);
    score = abs((z - median(z)) ./ iqr(z));
    i = score > tol;
    figure();
    plot(y, '.b');
    hold on;
    plot(find(i), y(i), 'or');
end
