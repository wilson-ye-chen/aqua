function U = apatcdf(X, Mu, Sig, Eta, Lda, Iot, W)
% U = apatcdf(X, Mu, Sig, Eta, Lda, Iot, W) evaluates the cdf of the
% Apatosaurus distribution.
%
% Input:
% X   - argument of the cdf. It can be a matrix, vector, or scalar.
% Mu  - location parameter of the truncated-skewed-t component, in
%       (-inf, inf).
% Sig - scale parameter of the truncated-skewed-t component, in (0, inf).
% Eta - tail-thickness parameter of the truncated-skewed-t component, in
%       (2, inf).
% Lda - asymmetry parameter of the truncated-skewed-t component, in (-1, 1).
% Iot - mean parameter of the Exponential component, in (0, inf).
% W   - mixing weight of the truncated-skewed-t component, in [0, 1].
%
% Output:
% U   - value of the cdf.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   November 28, 2015

    U = W .* trsktcdf(X, Mu, Sig, Eta, Lda) + ...
        (1 - W) .* expcdf(X, Iot);
end
