function [gh, fVal, exitFlag] = ghfit_mom(x)
% [gh, fVal, exitFlag] = ghfit_mom(x) estimates the parameters of the
% g-and-h distribution by matching the mean, standard deviation, skewness,
% and kurtosis of the g-and-h distribution to the sample counterparts.
% The method is detailed in Headrick, Kowalchuk, and Sheng (2008).
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   March 23, 2015

    % Sample skewness and kurtosis
    z3 = skewness(x);
    z4 = kurtosis(x);
    
    % Objective
    fun = @(gnh)distfun(gnh(1), gnh(2), z3, z4);
    
    % Initial values for g and h
    gnh0 = [0, 0.01];
    
    % Optimiser options
    opt = optimset( ...
        'Algorithm', 'interior-point', ...
        'UseParallel', 'never', ...
        'MaxIter', 50000, ...
        'MaxFunEvals', 100000, ...
        'Display', 'off');
    
    % Small positive number
    e = eps(double(1));
    
    % Numerically find g and h
    [gnh, fVal, exitFlag] = fmincon( ...
        fun, ...
        gnh0, ...
        [], [], [], [], ...
        [-1, 0], ...
        [1, 0.25 - e], ...
        [], ...
        opt);
    
    % Sample mean and standard deviation
    m = mean(x);
    s = std(x);
    
    % Mean and variance of g-and-h
    t = 5e-3;
    r1 = momlerp(gnh(1), gnh(2), t, 1);
    r2 = momlerp(gnh(1), gnh(2), t, 2);
    c2 = r2 - r1 .^ 2;
    
    % Solve for a and b given g and h
    b = s ./ sqrt(c2);
    a = m - b .* r1;
    gh = [a, b, gnh];
end

function dist = distfun(g, h, z3, z4)
    % Central moments
    t = 5e-3;
    r1 = momlerp(g, h, t, 1);
    r2 = momlerp(g, h, t, 2);
    r3 = momlerp(g, h, t, 3);
    r4 = momlerp(g, h, t, 4);
    c2 = r2 - r1 .^ 2;
    c3 = r3 - 3 .* r1 .* r2 + 2 .* r1 .^ 3;
    c4 = r4 - 4 .* r1 .* r3 + 6 .* r1 .^ 2 .* r2 - 3 .* r1 .^ 4;
    
    % Skewness and kurtosis
    zeta3 = c3 ./ c2 .^ (3 ./ 2);
    zeta4 = c4 ./ c2 .^ 2;
    
    % Distance from sample skewness and kurtosis
    zeta = [zeta3, zeta4];
    z = [z3, z4];
    d = zeta - z;
    dist = d * d';
    
    % In case of an overflow
    if isnan(dist)
        dist = realmax('double');
    end
end

function m = momlerp(g, h, t, k)
% m = momlerp(g, h, t, k) computes the k-th raw moment of
% the g-and-h distribution in a numerically stable manner
% by linearly interpolating the k-th moment if g <= |t|.

    if g >= 0 && g <= t
        m = lerp(g, ...
            0, ghmom([0, 1, 0, h], k), ...
            t, ghmom([0, 1, t, h], k));
    elseif g <= 0 && g >= -t
        m = lerp(g, ...
            -t, ghmom([0, 1, -t, h], k), ...
            0, ghmom([0, 1, 0, h], k));
    else
        m = ghmom([0, 1, g, h], k);
    end
end

function y = lerp(x, x0, y0, x1, y1)
% y = lerp(x, x0, y0, x1, y1) linearly interpolates
% between (x0, y0) and (x1, y1).

    y = y0 + (y1 - y0) .* (x - x0) ./ (x1 - x0);
end
