function [gh, fVal, exitFlag] = ghfit_qm(x, u)
% [gh, fVal, exitFlag] = ghfit_qm(x, u) estimates the parameters of the
% g-and-h distribution using the quantile-matching method of Xu, Iglewicz,
% and Chervoneva (2014).
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   March 23, 2015

    % Objective
    u = u(:)';
    qnt = quantile(x, u);
    fun = @(gh)distfun(x, u, qnt, gh);
    
    % Initial values for g-and-h parameters
    qrt = quantile(x, [0.25, 0.5, 0.75]);
    gh0 = [qrt(2), qrt(3) - qrt(1), 0, 0.01];
    
    % Optimiser options
    opt = optimset( ...
        'Algorithm', 'interior-point', ...
        'UseParallel', 'never', ...
        'MaxIter', 50000, ...
        'MaxFunEvals', 100000, ...
        'Display', 'off');
    
    % Small positive number
    e = eps(double(1));
    
    % Numerically minimise the distance function
    [gh, fVal, exitFlag] = fmincon( ...
        fun, ...
        gh0, ...
        [], [], [], [], ...
        [-inf, e, -1, 0], ...
        [inf, inf, 1, 1], ...
        [], ...
        opt);
end

function dist = distfun(x, u, qnt, gh)
    d = qnt - ghinv(u, gh);
    dist = d * d';
end
