function X = sktrnd(Mu, Sig, Eta, Lda, m, n)
% X = sktrnd(Mu, Sig, Eta, Lda, m, n) generates random numbers from the
% skewed-t distribution of Hansen (1994), parameterised by its mode, scale,
% asymmetry, and degrees-of-freedom. The parameters can be matrices, vectors,
% or scalars. They must be in the size of m-by-n when they are not scalars.
%
% Input:
% Mu  - location parameter and the mode, in (-inf, inf).
% Sig - scale parameter, in (0, inf).
% Eta - tail-thickness parameter, in (2, inf).
% Lda - asymmetry parameter, in (-1, 1).
% m   - number of rows in X.
% n   - number of columns in X.
%
% Output:
% X   - matrix of size m-by-n of random numbers.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   June 18, 2015

    U = unifrnd(0, 1, m, n);
    X = sktinv(U, Mu, Sig, Eta, Lda);
end
