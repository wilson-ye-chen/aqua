function k = kurt_moors(qfun)
% k = kurt_moors(qfun) computes the Moors' kurtosis given a quantile
% function. When qfun is the sample quantile function, k is the sample
% version of the measure. When qfun is a quantile function of a parametric
% distribution, k is the population measure.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   March 21, 2015

    oct = qfun((1:7) ./ 8);
    k = (oct(7) - oct(5) + oct(3) - oct(1)) ./ (oct(6) - oct(2));
end
