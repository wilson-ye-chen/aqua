function rSig = aqua_rsig_sktmar(psi, phi)
% rSig = aqua_rsig_sktmar(psi, phi) computes the signal ratio of the
% skewed-t conditional marginal model. The parameters can be scalars
% or vectors.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   January 2, 2016

    rSig = psi .^ 2 ./ (1 - 2 .* psi .* phi - phi .^ 2);
end
