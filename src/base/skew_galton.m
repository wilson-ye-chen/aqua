function g = skew_galton(qfun)
% g = skew_galton(qfun) computes the Galton's skewness given a quantile
% function. When qfun is the sample quantile function, g is the sample
% version of the measure. When qfun is a quantile function of a parametric
% distribution, g is the population measure.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   March 21, 2015

    qrt = qfun((1:3) ./ 4);
    g = (qrt(1) + qrt(3) - 2 .* qrt(2)) ./ (qrt(3) - qrt(1));
end
