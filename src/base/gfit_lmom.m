function [abg, fVal, exitFlag] = gfit_lmom(x)
% [abg, fVal, exitFlag] = gfit_lmom(x) estimates the parameters of the
% g-distribution using numerical method of L-moments.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   February 7, 2016

    % Sample L-moments and sample L-skewness
    l = lmom(x);
    l1 = l(1);
    l2 = l(2);
    t3 = l(3) ./ l2;
    
    % Objective
    fun = @(g)distfun(g, t3);
    
    % Initial values for g
    g0 = 0;
    
    % Optimiser options
    opt = optimset( ...
        'Algorithm', 'interior-point', ...
        'UseParallel', 'never', ...
        'MaxIter', 50000, ...
        'MaxFunEvals', 100000, ...
        'Display', 'off');
    
    % Numerically find the value of the g parameter
    [g, fVal, exitFlag] = fmincon( ...
        fun, ...
        g0, ...
        [], [], [], [], ...
        -1, 1, ...
        [], ...
        opt);
    
    % First and second L-moments of g-distribution
    f2 = @(u)qfun(u, g) .* (2 .* u - 1);
    lam1 = ghmom([0, 1, g, 0], 1);
    lam2 = integral(f2, 0, 1);
    
    % Solve for a and b given g and h
    b = l2 ./ lam2;
    a = l1 - b .* lam1;
    abg = [a, b, g];
end

function dist = distfun(g, t3)
    % Numerical L-moments of the g-distribution
    f2 = @(u)qfun(u, g) .* (2 .* u - 1);
    f3 = @(u)qfun(u, g) .* (6 .* u .^ 2 - 6 .* u + 1);
    lam2 = integral(f2, 0, 1);
    lam3 = integral(f3, 0, 1);
    
    % L-skewness of the g-distribution
    tau3 = lam3 ./ lam2;
    
    % Distance from sample L-skewness
    dist = (tau3 - t3) .^ 2;
end

function q = qfun(u, g)
    z = norminv(u, 0, 1);
    if g
        q = (exp(g .* z) - 1) ./ g;
    else
        q = z;
    end
end
