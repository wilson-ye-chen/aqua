function X = apatrnd(Mu, Sig, Eta, Lda, Iot, W, m, n)
% X = apatrnd(Mu, Sig, Eta, Lda, Iot, W, m, n) generates random numbers from
% the Apatosaurus distribution. The parameters can be matrices, vectors, or
% scalars. They must be in the size of m-by-n when they are not scalars.
%
% Input:
% Mu  - location parameter of the truncated-skewed-t component, in
%       (-inf, inf).
% Sig - scale parameter of the truncated-skewed-t component, in (0, inf).
% Eta - tail-thickness parameter of the truncated-skewed-t component, in
%       (2, inf).
% Lda - asymmetry parameter of the truncated-skewed-t component, in (-1, 1).
% Iot - mean parameter of the Exponential component, in (0, inf).
% W   - mixing weight of the truncated-skewed-t component, in [0, 1].
% m   - number of rows in X.
% n   - number of columns in X.
%
% Output:
% X   - matrix of size m-by-n of random numbers.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   November 28, 2015

    ITr = logical(binornd(1, W, m, n));
    IEx = ~ITr;
    X = zeros(m, n);
    
    if ~isscalar(Mu)
        Mu = Mu(ITr);
    end
    if ~isscalar(Sig)
        Sig = Sig(ITr);
    end
    if ~isscalar(Eta)
        Eta = Eta(ITr);
    end
    if ~isscalar(Lda)
        Lda = Lda(ITr);
    end
    if ~isscalar(Iot)
        Iot = Iot(IEx);
    end
    
    X(ITr) = trsktrnd(Mu, Sig, Eta, Lda, nnz(ITr), 1);
    X(IEx) = exprnd(Iot, nnz(IEx), 1);
end
