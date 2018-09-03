function M = apatmean(Mu, Sig, Eta, Lda, Iot, W)
% M = apatmean(Mu, Sig, Eta, Lda, Iot, W) evaluates the mean of the
% Apatosaurus distribution. The parameters can be matrices, vectors, or
% scalars. All parameters must be in the same size when they are not scalars.
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
%
% Output:
% M   - value of the mean given the parameters.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   November 28, 2015

    MTr = trsktmean(Mu, Sig, Eta, Lda);
    M = W .* MTr + (1 - W) .* Iot;
end
