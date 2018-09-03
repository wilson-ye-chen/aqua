function [gh, fVal, exitFlag] = ghfit_ml(x)
% [gh, fVal, exitFlag] = ghfit_ml(x) estimates the parameters of the
% g-and-h distribution using numerical maximum likelihood. This procedure
% is computationally demanding for large number of observations, due to
% the numerical inversion of the quantile function.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   March 23, 2015

    % Negative log-likelihood
    fun = @(gh)-loglike(x, gh);
    
    % Initial values for g-and-h parameters
    qrt = quantile(x, [0.25, 0.5, 0.75]);
    gh0 = [qrt(2), qrt(3) - qrt(1), 0, 0.01];
    
    % Optimiser options
    opt = optimset( ...
        'Algorithm', 'interior-point', ...
        'UseParallel', 'never', ...
        'MaxIter', 50000, ...
        'MaxFunEvals', 100000, ...
        'DiffMinChange', 1e-5, ...
        'Display', 'off');
    
    % Small positive number
    e = eps(double(1));
    
    % Numerically minimise the negative log-likelihood
    [gh, fVal, exitFlag] = fmincon( ...
        fun, ...
        gh0, ...
        [], [], [], [], ...
        [-inf, e, -1, 0], ...
        [inf, inf, 1, 1], ...
        [], ...
        opt);
end

function ll = loglike(x, gh)
    nObs = numel(x);
    y = zeros(nObs, 1);
    e = eps(double(0));
    for i = 1:nObs
        y(i) = ghpdf(x(i), gh, 1e-5);
        if y(i) < e
            y(i) = e;
        end
    end
    ll = sum(log(y));
end
