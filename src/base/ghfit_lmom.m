function [gh, fVal, exitFlag] = ghfit_lmom(x)
% [gh, fVal, exitFlag] = ghfit_lmom(x) estimates the parameters of the
% g-and-h distribution using numerical method of L-moments.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   March 23, 2015

    % Sample L-moments and sample L-moment ratios
    l = lmom(x);
    l1 = l(1);
    l2 = l(2);
    t3 = l(3) ./ l2;
    t4 = l(4) ./ l2;
    
    % Objective
    fun = @(gnh)distfun(gnh(1), gnh(2), t3, t4);
    
    % Initial values for g and h
    gnh0 = [0, 0.01];
    
    % Optimiser options
    opt = optimset( ...
        'Algorithm', 'interior-point', ...
        'UseParallel', 'never', ...
        'MaxIter', 50000, ...
        'MaxFunEvals', 100000, ...
        'Display', 'off');
    
    % Numerically find the shape parameters
    [gnh, fVal, exitFlag] = fmincon( ...
        fun, ...
        gnh0, ...
        [], [], [], [], ...
        [-1, 0], ...
        [1, 1], ...
        [], ...
        opt);
    
    % First and second L-moments of g-and-h
    f2 = @(u)qfun(u, gnh(1), gnh(2)) .* (2 .* u - 1);
    lam1 = ghmom([0, 1, gnh(1), gnh(2)], 1);
    lam2 = integral(f2, 0, 1);
    
    % Solve for a and b given g and h
    b = l2 ./ lam2;
    a = l1 - b .* lam1;
    gh = [a, b, gnh];
end

function dist = distfun(g, h, t3, t4)
    % Numerical L-moments of the g-and-h
    f2 = @(u)qfun(u, g, h) .* (2 .* u - 1);
    f3 = @(u)qfun(u, g, h) .* (6 .* u .^ 2 - 6 .* u + 1);
    f4 = @(u)qfun(u, g, h) .* (20 .* u .^ 3 - 30 .* u .^ 2 + 12 .* u - 1);
    lam2 = integral(f2, 0, 1);
    lam3 = integral(f3, 0, 1);
    lam4 = integral(f4, 0, 1);
    
    % L-moment ratios of the g-and-h
    tau3 = lam3 ./ lam2;
    tau4 = lam4 ./ lam2;
    
    % Distance from sample L-moment ratios
    tau = [tau3, tau4];
    t = [t3, t4];
    d = tau - t;
    dist = d * d';
end

function q = qfun(u, g, h)
    z = norminv(u, 0, 1);
    if g
        q = (exp(g .* z) - 1) ./ g .* exp(h .* z .^ 2 ./ 2);
    else
        q = z .* exp(h .* z .^ 2 ./ 2);
    end
end
