function Y = stdsktpdf(X, eta, lda)
% Y = stdsktpdf(X, eta, lda) evaluates the pdf of the standardised
% skewed-t distribution of Hansen (1994).
%
% Input:
% X   - argument of the pdf. It can be a matrix, vector, or scalar.
% eta - tail-thickness parameter. It must be a scalar in (2, inf).
% lda - asymmetry parameter. It must be a scalar in (-1, 1).
%
% Output:
% Y   - value of the pdf. It has the same size as X.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   December 28, 2014

    c = 1 ./ sqrt(pi .* (eta - 2)) .* ...
        gamma((eta + 1) ./ 2) ./ gamma(eta ./ 2);
    a = 4 .* lda .* c .* (eta - 2) ./ (eta - 1);
    b = sqrt(1 + 3 .* lda .^ 2 - a .^ 2);
    
    Il = X < -(a ./ b);
    Ir = ~Il;
    
    Y = zeros(size(X));
    T = b .* X + a;
    Y(Il) = ...
        b .* c .* ...
        (1 + 1 ./ (eta - 2) .* (T(Il) ./ (1 - lda)) .^ 2) .^ ...
        (-(eta + 1) ./ 2);
    Y(Ir) = ...
        b .* c .* ...
        (1 + 1 ./ (eta - 2) .* (T(Ir) ./ (1 + lda)) .^ 2) .^ ...
        (-(eta + 1) ./ 2);
end
