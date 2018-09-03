function Y = halfcauchypdf(X, sigma)
% Y = halfcauchypdf(X, sigma) evaluates the pdf of the half-Cauchy
% distribution.
%
% Input:
% X     - argument of the pdf. It can be a scalar, vector or matrix.
% sigma - scale parameter. It must be a scalar.
%
% Output:
% Y     - value of the pdf. It has the same size as X.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   December 28, 2015

    Y = 2 ./ (pi .* (sigma + X .^ 2 ./ sigma));
end
