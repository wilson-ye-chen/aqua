function [abh, fVal, exitFlag] = hfit_lmom(x)
% [abh, fVal, exitFlag] = hfit_lmom(x) estimates the parameters of the
% h-distribution using numerical method of L-moments.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   February 7, 2015

    % Sample L-moments and sample L-kurtosis
    l = lmom(x);
    l1 = l(1);
    l2 = l(2);
    t4 = l(4) ./ l2;
    
    % Objective
    fun = @(h)distfun(h, t4);
    
    % Initial values for h
    h0 = 0.01;
    
    % Optimiser options
    opt = optimset( ...
        'Algorithm', 'interior-point', ...
        'UseParallel', 'never', ...
        'MaxIter', 50000, ...
        'MaxFunEvals', 100000, ...
        'Display', 'off');
    
    % Numerically find the shape parameters
    [h, fVal, exitFlag] = fmincon( ...
        fun, ...
        h0, ...
        [], [], [], [], ...
        0, 1, ...
        [], ...
        opt);
    
    % First and second L-moments of h-distribution
    f2 = @(u)qfun(u, h) .* (2 .* u - 1);
    lam1 = ghmom([0, 1, 0, h], 1);
    lam2 = integral(f2, 0, 1);
    
    % Solve for a and b given h
    b = l2 ./ lam2;
    a = l1 - b .* lam1;
    abh = [a, b, h];
end

function dist = distfun(h, t4)
    % Numerical L-moments of the h-distribution
    f2 = @(u)qfun(u, h) .* (2 .* u - 1);
    f4 = @(u)qfun(u, h) .* (20 .* u .^ 3 - 30 .* u .^ 2 + 12 .* u - 1);
    lam2 = integral(f2, 0, 1);
    lam4 = integral(f4, 0, 1);
    
    % L-kurtosis of the h-distribution
    tau4 = lam4 ./ lam2;
    
    % Distance from sample L-kurtosis
    dist = (tau4 - t4) .^ 2;
end

function q = qfun(u, h)
    z = norminv(u, 0, 1);
    q = z .* exp(h .* z .^ 2 ./ 2);
end
