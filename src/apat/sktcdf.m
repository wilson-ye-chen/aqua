function U = sktcdf(X, Mu, Sig, Eta, Lda)
% U = sktcdf(X, Mu, Sig, Eta, Lda) evaluates the cdf of the skewed-t
% distribution of Hansen (1994), parameterised by its mode, scale, asymmetry,
% and degrees-of-freedom. The parameters can be matrices, vectors, or scalars.
% They must be in the same size when they are not scalars.
%
% Input:
% X   - argument of the cdf. It can be a matrix, vector, or scalar.
% Mu  - location parameter and the mode, in (-inf, inf).
% Sig - scale parameter, in (0, inf).
% Eta - tail-thickness parameter, in (2, inf).
% Lda - asymmetry parameter, in (-1, 1).
%
% Output:
% U   - value of the cdf.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   June 24, 2015

    Dim = [size(X); size(Mu); size(Sig); size(Eta); size(Lda)];
    maxDim = max(Dim, [], 1);
    U = zeros(maxDim);
    
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
    if ~isscalar(Sig);
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
    
    sL = sqrt(etaL ./ (etaL - 2));
    sR = sqrt(etaR ./ (etaR - 2));
    U(Il) = ...
        (1 - ldaL) .* ...
        tcdf((X(Il) - muL) ./ (sigL .* (1 - ldaL)) .* sL, etaL);
    U(Ir) = ...
        (1 + ldaR) .* ...
        tcdf((X(Ir) - muR) ./ (sigR .* (1 + ldaR)) .* sR, etaR) - ldaR;
end
