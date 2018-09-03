function M = trsktmean(Mu, Sig, Eta, Lda)
% M = trsktmean(Mu, Sig, Eta, Lda) evaluates the mean of the truncated-
% skewed-t distribution of Hansen (1994), parameterised by its pre-truncated
% mode, scale, asymmetry, and degrees-of-freedom. The parameters can be
% matrices, vectors, or scalars. All other parameters must be in the same
% size when they are not scalars.
%
% Input:
% Mu  - location parameter and the mode before truncation, in (-inf, inf).
% Sig - scale parameter, in (0, inf).
% Eta - tail-thickness parameter, in (2, inf).
% Lda - asymmetry parameter, in (-1, 1).
%
% Output:
% M   - value of the mean given the parameters. It has the same size as Mu.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   June 24, 2015

    C = gamma((Eta + 1) ./ 2) ./ (sqrt(pi .* (Eta - 2)) .* gamma(Eta ./ 2));
    K = 1 + 1 ./ (Eta - 2) .* (-Mu ./ (Sig .* (1 - Lda))) .^ 2;
    M = C .* Sig .* (Eta - 2) ./ (Eta - 1) .* ...
        ((1 + Lda) .^ 2 - (1 - Lda) .^ 2 .* ...
        (1 - K .^ ((1 - Eta) ./ 2))) ./ ...
        (1 - sktcdf(-Mu, 0, Sig, Eta, Lda)) + Mu;
end
