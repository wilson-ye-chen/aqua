function U = trsktcdf(X, Mu, Sig, Eta, Lda)
% U = trsktcdf(X, Mu, Sig, Eta, Lda) evaluates the cdf of the truncated-
% skewed-t distribution of Hansen (1994), parameterised by its pre-truncated
% mode, scale, asymmetry, and degrees-of-freedom. The parameters can be
% matrices, vectors, or scalars. They must be in the same size when they are
% not scalars.
%
% Input:
% X   - argument of the cdf. It can be a matrix, vector, or scalar.
% Mu  - location parameter and the mode before truncation, in (-inf, inf).
% Sig - scale parameter, in (0, inf).
% Eta - tail-thickness parameter, in (2, inf).
% Lda - asymmetry parameter, in (-1, 1).
%
% Output:
% U   - value of the cdf.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   June 24, 2015

    K = sktcdf(0, Mu, Sig, Eta, Lda);
    U = (sktcdf(X, Mu, Sig, Eta, Lda) - K) ./ (1 - K);
end
