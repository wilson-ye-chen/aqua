function X = trsktinv(U, Mu, Sig, Eta, Lda)
% X = trsktinv(U, Mu, Sig, Eta, Lda) evaluates the inverse-cdf of the
% truncated-skewed-t distribution of Hansen (1994), parameterised by its
% pre-truncated mode, scale, asymmetry, and degrees-of-freedom. The
% parameters can be matrices, vectors, or scalars. They must be in the same
% size when they are not scalars.
%
% Input:
% U   - argument of the inverse-cdf. It can be a matrix, vector, or scalar.
% Mu  - location parameter and the mode before truncation, in (-inf, inf).
% Sig - scale parameter, in (0, inf).
% Eta - tail-thickness parameter, in (2, inf).
% Lda - asymmetry parameter, in (-1, 1).
%
% Output:
% X   - value of the inverse-cdf.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   June 24, 2015

    K = sktcdf(0, Mu, Sig, Eta, Lda);
    X = sktinv(U .* (1 - K) + K, Mu, Sig, Eta, Lda);
end
