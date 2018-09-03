function X = sktinv(U, Mu, Sig, Eta, Lda)
% X = sktinv(U, Mu, Sig, Eta, Lda) evaluates the inverse-cdf of the skewed-t
% distribution of Hansen (1994), parameterised by its mode, scale, asymmetry,
% and degrees-of-freedom. The parameters can be matrices, vectors, or scalars.
% They must be in the same size when they are not scalars.
%
% Input:
% U   - argument of the inverse-cdf. It can be a matrix, vector, or scalar.
% Mu  - location parameter and the mode, in (-inf, inf).
% Sig - scale parameter, in (0, inf).
% Eta - tail-thickness parameter, in (2, inf).
% Lda - asymmetry parameter, in (-1, 1).
%
% Output:
% X   - value of the inverse-cdf.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   June 24, 2015

    Dim = [size(U); size(Mu); size(Sig); size(Eta); size(Lda)];
    maxDim = max(Dim, [], 1);
    X = zeros(maxDim);
    
    if isscalar(U)
        U = repmat(U, maxDim);
    end
    
    Il = (U < (1 - Lda) ./ 2);
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
    
    sL = sqrt((etaL - 2) ./ etaL);
    sR = sqrt((etaR - 2) ./ etaR);
    X(Il) = ...
        sigL .* (1 - ldaL) .* sL .* ...
        tinv(U(Il) ./ (1 - ldaL), etaL) + muL;
    X(Ir) = ...
        sigR .* (1 + ldaR) .* sR .* ...
        tinv((U(Ir) + ldaR) ./ (1 + ldaR), etaR) + muR;
end
