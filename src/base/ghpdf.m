function y = ghpdf(x, gh, dx)
% y = ghpdf(x, gh, dx) evaluates the density function of the g-and-h
% distribution by numerically differentiating the inverse of the quantile
% function, where the derivative is approximated by the central-difference
% estimate.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   March 3, 2015

    u1 = ghcdf(x - dx, gh);
    u2 = ghcdf(x + dx, gh);
    y = (u2 - u1) ./ (2 .* dx);
end
