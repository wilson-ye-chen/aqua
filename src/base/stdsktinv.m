function X = stdsktinv(U, eta, lda)
% X = stdsktinv(U, eta, lda) evaluates the quantile function of the
% standardised skewed-t distribution of Hansen (1994). The expression
% of the quantile function is given by Jondeau and Rockinger (2003).
%
% Input:
% U   - argument of the quantile function. It can be a matrix, vector,
%       or scalar.
% eta - tail-thickness parameter. It must be a scalar in (2, inf).
% lda - asymmetry parameter. It must be a scalar in (-1, 1).
%
% Output:
% X   - value of the quantile function. It has the same size as U.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   December 29, 2014

    c = 1 ./ sqrt(pi .* (eta - 2)) .* ...
        gamma((eta + 1) ./ 2) ./ gamma(eta ./ 2);
    a = 4 .* lda .* c .* (eta - 2) ./ (eta - 1);
    b = sqrt(1 + 3 .* lda .^ 2 - a .^ 2);
    
    Il = U < (1 - lda) ./ 2;
    Ir = ~Il;
    
    X = zeros(size(U));
    s = sqrt((eta - 2) ./ eta);
    ArgL = U(Il) ./ (1 - lda);
    ArgR = (U(Ir) + lda) ./ (1 + lda);
    X(Il) = ((1 - lda) .* s .* tinv(ArgL, eta) - a) ./ b;
    X(Ir) = ((1 + lda) .* s .* tinv(ArgR, eta) - a) ./ b;
end
