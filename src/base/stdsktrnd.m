function X = stdsktrnd(eta, lda, m, n)
% X = stdsktrnd(eta, lda, m, n) generates random numbers from the
% standardised skewed-t distribution of Hansen (1994).
%
% Input:
% eta - tail-thickness parameter. It must be a scalar in (2, inf).
% lda - asymmetry parameter. It must be a scalar in (-1, 1).
% m   - number of rows in X.
% n   - number of columns in X.
%
% Output:
% X   - matrix of size m-by-n of random numbers.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   December 29, 2014

    U = unifrnd(0, 1, m, n);
    X = stdsktinv(U, eta, lda);
end
