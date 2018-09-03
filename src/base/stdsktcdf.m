function U = stdsktcdf(X, eta, lda)
% U = stdsktcdf(X, eta, lda) evaluates the cdf of the standardised
% skewed-t distribution of Hansen (1994). The expression of the cdf
% is given by Jondeau and Rockinger (2003).
%
% Input:
% X   - argument of the pdf. It can be a matrix, vector, or scalar.
% eta - tail-thickness parameter. It must be a scalar in (2, inf).
% lda - asymmetry parameter. It must be a scalar in (-1, 1).
%
% Output:
% U   - value of the cdf. It has the same size as X.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   December 28, 2014

    c = 1 ./ sqrt(pi .* (eta - 2)) .* ...
        gamma((eta + 1) ./ 2) ./ gamma(eta ./ 2);
    a = 4 .* lda .* c .* (eta - 2) ./ (eta - 1);
    b = sqrt(1 + 3 .* lda .^ 2 - a .^ 2);
    
    Il = X < -(a ./ b);
    Ir = ~Il;
    
    U = zeros(size(X));
    T = b .* X + a;
    s = sqrt(eta ./ (eta - 2));
    U(Il) = (1 - lda) .* tcdf(T(Il) ./ (1 - lda) .* s, eta);
    U(Ir) = (1 + lda) .* tcdf(T(Ir) ./ (1 + lda) .* s, eta) - lda;
end
