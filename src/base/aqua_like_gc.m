function logLike = aqua_like_gc(a, b, g, h, c, mu0, nSigmaSq0, nPre, Xi)
% logLike = aqua_like_gc(a, b, g, h, c, mu0, nSigmaSq0, nPre, Xi) evaluates
% the log-likelihood of the gh-AQUA model, where the dependencies are modelled
% using a Gaussian copula, the conditional marginal distributions of a,
% log(b), and g are skewed-t, and those of h are Apatosaurus. The
% implementation is optimised for a Gibbs sampling scheme where each of the a,
% b, g, h, and c is sampled in turn conditional on the others.
%
% Input:
% a         - vector of parameters of the marginal model of a.
% b         - vector of parameters of the maringal model of log(b).
% g         - vector of parameters of the maringal model of g.
% h         - vector of parameters of the marginal model of h.
% c         - vector of correlations.
% mu0       - vector of initial values of the conditional mean recursions.
% nSigmaSq0 - number of initial mean-adjusted observations to be averaged
%             over to compute the initial values of the conditional variance
%             recursions.
% nPre      - number of pre-samples; number of observations at the start of
%             the recursions ignored by the likelihood calculation.
% Xi        - matrix of observations, where each row is an observation and
%             each column is a mapped parameter.
%
% Output:
% logLike   - value of the log-likelihood.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   November 29, 2015

    % Static variables are initialised to empty matrices
    persistent aOld bOld gOld hOld cOld;
    persistent ilgA ilgB ilgG ilgH ilgC;
    persistent llA llB llG llH;
    persistent xA xB xG xH;
    persistent T sumLogDiag;
    
    % Marginal model of a
    if ~isequal(a, aOld)
        aOld = a;
        [llA, z] = aqua_like_sktmar( ...
            a(1), a(2), a(3), ...
            a(4), a(5), a(6), ...
            a(7), a(8), ...
            mu0(1), nSigmaSq0, nPre, Xi(:, 1));
        if ~isinf(llA)
            u = stdsktcdf(z, a(7), a(8));
            xA = norminv(u, 0, 1);
            ilgA = false;
        else
            ilgA = true;
        end
    end
    
    % Marginal model of log(b)
    if ~isequal(b, bOld)
        bOld = b;
        [llB, z] = aqua_like_sktmar( ...
            b(1), b(2), b(3), ...
            b(4), b(5), b(6), ...
            b(7), b(8), ...
            mu0(2), nSigmaSq0, nPre, Xi(:, 2));
        if ~isinf(llB)
            u = stdsktcdf(z, b(7), b(8));
            xB = norminv(u, 0, 1);
            ilgB = false;
        else
            ilgB = true;
        end
    end
    
    % Marginal model of g
    if ~isequal(g, gOld)
        gOld = g;
        [llG, z] = aqua_like_sktmar( ...
            g(1), g(2), g(3), ...
            g(4), g(5), g(6), ...
            g(7), g(8), ...
            mu0(3), nSigmaSq0, nPre, Xi(:, 3));
        if ~isinf(llG)
            u = stdsktcdf(z, g(7), g(8));
            xG = norminv(u, 0, 1);
            ilgG = false;
        else
            ilgG = true;
        end
    end
    
    % Marginal model of h
    if ~isequal(h, hOld)
        hOld = h;
        [llH, mu, w] = aqua_like_apatmar( ...
            h(1), h(2), h(3), h(4), h(5), ...
            h(6), h(7), h(8), h(9), ...
            mu0(4), nPre, Xi(:, 4));
        if ~isinf(llH)
            u = apatcdf(Xi((nPre + 1):end, 4), ...
                mu, h(6), h(7), h(8), h(9), w);
            xH = norminv(u, 0, 1);
            ilgH = false;
        else
            ilgH = true;
        end
    end
    
    % Correlations
    if ~isequal(c, cOld)
        cOld = c;
        R = c2r(c);
        [T, notPd] = chol(R, 'upper');
        if notPd || any(abs(c) > 1)
            ilgC = true;
        else
            sumLogDiag = sum(log(diag(T)));
            ilgC = false;
        end
    end
    
    % Gaussian copula likelihood
    if ilgA || ilgB || ilgG || ilgH || ilgC
        logLike = -inf;
    else
        X = [xA, xB, xG, xH];
        Z = X / T;
        lcd = -0.5 .* sum(Z .^ 2 - X .^ 2, 2) - sumLogDiag;
        logLike = sum(lcd) + llA + llB + llG + llH;
    end
end

function R = c2r(c)
    R = [ ...
        1, c(1), c(2), c(3); ...
        c(1), 1, c(4), c(5); ...
        c(2), c(4), 1, c(6); ...
        c(3), c(5), c(6), 1 ...
        ];
end
