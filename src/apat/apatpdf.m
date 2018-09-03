function Y = apatpdf(X, Mu, Sig, Eta, Lda, Iot, W)
% Y = apatpdf(X, Mu, Sig, Eta, Lda, Iot, W) evaluates the pdf of the
% Apatosaurus distribution.
%
% Input:
% X   - argument of the pdf. It can be a matrix, vector, or scalar.
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
% Y   - value of the pdf.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   November 28, 2015

    Y = W .* trsktpdf(X, Mu, Sig, Eta, Lda) + ...
        (1 - W) .* exppdf(X, Iot);
end
