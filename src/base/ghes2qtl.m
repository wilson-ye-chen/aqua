function [uQtl, es, fVal, exitFlag] = ghes2qtl(uEs, gh)
% [uQtl, es, fVal, exitFlag] = ghes2qtl(uEs, gh) finds the corresponding
% quantile level given a level of Expected Shortfall for the g-and-h
% distribution. The ES is found by simulating from the left-tail with a
% sample size of 200,000. The corresponding quantile level is then found
% by numerical root search.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   December 1, 2015

    % Compute ES by simulating from the g-and-h tail
    n = 200000;
    u = unifrnd(0, uEs, n, 1);
    x = ghinv(u, repmat(gh, n, 1));
    es = mean(x);
    
    % Find the corresponding quantile via root search
    fun = @(u)ghinv(u, gh) - es;
    [uQtl, fVal, exitFlag] = fzero(fun, [1e-5, (1 - 1e-5)]);
end
