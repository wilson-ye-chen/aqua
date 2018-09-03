function Y = sktpdf(X, Mu, Sig, Eta, Lda)
% Y = sktpdf(X, Mu, Sig, Eta, Lda) evaluates the pdf of the skewed-t
% distribution of Hansen (1994), parameterised by its mode, scale,
% asymmetry, and degrees-of-freedom. The parameters can be matrices,
% vectors, or scalars. They must be in the same size when they are
% not scalars.
%
% Input:
% X   - argument of the pdf. It can be a matrix, vector, or scalar.
% Mu  - location parameter and the mode in (-inf, inf).
% Sig - scale parameter in (0, inf).
% Eta - tail-thickness parameter in (2, inf).
% Lda - asymmetry parameter in (-1, 1).
%
% Output:
% Y   - value of the pdf.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   June 24, 2015

    Dim = [size(X); size(Mu); size(Sig); size(Eta); size(Lda)];
    maxDim = max(Dim, [], 1);
    Y = zeros(maxDim);
    
    if isscalar(X)
        X = repmat(X, maxDim);
    end
    
    Il = (X < Mu);
    Ir = ~Il;
    
    if ~isscalar(Mu)
        muL = Mu(Il);
        muR = Mu(Ir);
    else
        muL = Mu;
        muR = Mu;
    end
    if ~isscalar(Sig)
        sigL = Sig(Il);
        sigR = Sig(Ir);
    else
        sigL = Sig;
        sigR = Sig;
    end
    if ~isscalar(Eta)
        etaL = Eta(Il);
        etaR = Eta(Ir);
    else
        etaL = Eta;
        etaR = Eta;
    end
    if ~isscalar(Lda)
        ldaL = Lda(Il);
        ldaR = Lda(Ir);
    else
        ldaL = Lda;
        ldaR = Lda;
    end
    
    cL = ...
        gamma((etaL + 1) ./ 2) ./ ...
        (sqrt(pi .* (etaL - 2)) .* gamma(etaL ./ 2));
    cR = ...
        gamma((etaR + 1) ./ 2) ./ ...
        (sqrt(pi .* (etaR - 2)) .* gamma(etaR ./ 2));
    
    Y(Il) = ...
        cL ./ sigL .* ...
        (1 + 1 ./ (etaL - 2) .* ...
        ((X(Il) - muL) ./ (sigL .* (1 - ldaL))) .^ 2) .^ ...
        (-(etaL + 1) ./ 2);
    Y(Ir) = ...
        cR ./ sigR .* ...
        (1 + 1 ./ (etaR - 2) .* ...
        ((X(Ir) - muR) ./ (sigR .* (1 + ldaR))) .^ 2) .^ ...
        (-(etaR + 1) ./ 2);
end
