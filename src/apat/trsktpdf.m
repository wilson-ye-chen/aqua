function Y = trsktpdf(X, Mu, Sig, Eta, Lda)
% Y = trsktpdf(X, Mu, Sig, Eta, Lda) evaluates the pdf of the truncated-
% skewed-t distribution of Hansen (1994), parameterised by its pre-truncated
% mode, scale, asymmetry, and degrees-of-freedom. The parameters can be
% matrices, vectors, or scalars. They must be in the same size when they
% are not scalars.
%
% Input:
% X   - argument of the pdf. It can be a matrix, vector, or scalar.
% Mu  - location parameter and the mode before truncation, in (-inf, inf).
% Sig - scale parameter, in (0, inf).
% Eta - tail-thickness parameter, in (2, inf).
% Lda - asymmetry parameter, in (-1, 1).
%
% Output:
% Y   - value of the pdf.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   June 24, 2015

    K = 1 - sktcdf(0, Mu, Sig, Eta, Lda);
    Y = sktpdf(X, Mu, Sig, Eta, Lda) ./ K;
end
