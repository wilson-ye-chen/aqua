function [abgk, fVal, exitFlag] = gkfit_lmom(x, c)
% [abgk, fVal, exitFlag] = gkfit_lmom(x, c) estimates the parameters of the
% g-and-k distribution using numerical method of L-moments.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   February 9, 2016

    % Sample L-moments and sample L-moment ratios
    l = lmom(x);
    l1 = l(1);
    l2 = l(2);
    t3 = l(3) ./ l2;
    t4 = l(4) ./ l2;
    
    % Objective
    fun = @(gk)distfun(gk(1), gk(2), t3, t4, c);
    
    % Initial values for g and k
    gk0 = [0, 0.01];
    
    % Optimiser options
    opt = optimset( ...
        'Algorithm', 'interior-point', ...
        'UseParallel', 'never', ...
        'MaxIter', 50000, ...
        'MaxFunEvals', 100000, ...
        'Display', 'off');
    
    % Numerically find the shape parameters
    [gk, fVal, exitFlag] = fmincon( ...
        fun, ...
        gk0, ...
        [], [], [], [], ...
        [-inf, -0.5], ...
        [inf, inf], ...
        [], ...
        opt);
    
    % First and second L-moments of g-and-k
    f1 = @(u)qfun(u, gk(1), gk(2), c);
    f2 = @(u)qfun(u, gk(1), gk(2), c) .* (2 .* u - 1);
    lam1 = integral(f1, 0, 1);
    lam2 = integral(f2, 0, 1);
    
    % Solve for a and b given g and k
    b = l2 ./ lam2;
    a = l1 - b .* lam1;
    abgk = [a, b, gk];
end

function dist = distfun(g, k, t3, t4, c)
    % Numerical L-moments of the g-and-k
    f2 = @(u)qfun(u, g, k, c) .* (2 .* u - 1);
    f3 = @(u)qfun(u, g, k, c) .* (6 .* u .^ 2 - 6 .* u + 1);
    f4 = @(u)qfun(u, g, k, c) .* (20 .* u .^ 3 - 30 .* u .^ 2 + 12 .* u - 1);
    lam2 = integral(f2, 0, 1);
    lam3 = integral(f3, 0, 1);
    lam4 = integral(f4, 0, 1);
    
    % L-moment ratios of the g-and-k
    tau3 = lam3 ./ lam2;
    tau4 = lam4 ./ lam2;
    
    % Distance from sample L-moment ratios
    tau = [tau3, tau4];
    t = [t3, t4];
    d = tau - t;
    dist = d * d';
end

function q = qfun(u, g, k, c)
    z = norminv(u, 0, 1);
    gz = 1 + c .* (1 - exp(-g .* z)) ./ (1 + exp(-g .* z));
    kz = (1 + z .^ 2) .^ k;
    q = gz .* kz .* z;
end
