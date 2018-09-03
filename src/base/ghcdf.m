function [u, fVal, exitFlag] = ghcdf(x, gh)
% [u, fVal, exitFlag] = ghcdf(x, gh) numerically inverts the quantile
% function of the g-and-h distribution.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   March 4, 2015

    uLower = 1e-10;
    uUpper = 1 - 1e-10;
    if x < ghinv(uLower, gh)
        u = 0;
        fVal = [];
        exitFlag = [];
    elseif x > ghinv(uUpper, gh)
        u = 1;
        fVal = [];
        exitFlag = [];
    else
        fun = @(u)ghinv(u, gh) - x;
        [u, fVal, exitFlag] = fzero(fun, [uLower, uUpper]);
    end
end
