function [skt, fVal, exitFlag] = sktfit_ml(x)
% [skt, fVal, exitFlag] = sktfit_ml(x) estimates the parameters of the
% skewed-t distribution using maximum likelihood.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   April 7, 2016

    % Negative log-likelihood
    fun = @(skt)-loglike(x, skt);
    
    % Initial values for skewed-t parameters
    skt0 = [mean(x), std(x), 8, 0];
    
    % Optimiser options
    opt = optimset( ...
        'Algorithm', 'interior-point', ...
        'UseParallel', 'never', ...
        'MaxIter', 50000, ...
        'MaxFunEvals', 100000, ...
        'Display', 'off');
    
    % Small positive number
    e = eps(double(1));
    
    % Numerically minimise the negative log-likelihood
    [skt, fVal, exitFlag] = fmincon( ...
        fun, ...
        skt0, ...
        [], [], [], [], ...
        [-inf, e, 1, -1], ...
        [inf, inf, 200, 1], ...
        [], ...
        opt);
end

function ll = loglike(x, skt)
    mu = skt(1);
    sig = skt(2);
    eta = skt(3);
    lda = skt(4);
    ll = sum(log(stdsktpdf((x - mu) ./ sig, eta, lda) ./ sig));
end
