function [rSig, iThin] = aqua_rsigpost_apatmar(Theta, nThin)
% [rSig, iThin] = aqua_rsigpost_apatmar(Theta, nThin) generates a sample
% from the posterior of the signal ratio for the Apatosaurus conditional
% marginal model, based on MCMC output. (This function is preferred over
% aqua_rsig when computing posterior draws of the signal ratio for the
% Apatosaurus conditional marginal model.)
%
% Input:
% Theta - matrix of sampled parameter vectors, where each row corresponds
%         to an observation and each column corresponds to a parameter.
% nThin - number of posterior draws after thinning, e.g., 500.
%
% Output:
% rSig  - vector of posterior samples of the signal ratio.
% iThin - vector of row indices of Theta, encoding the kept draws after
%         thinning.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   June 30, 2017

    iThin = round(linspace(1, size(Theta, 1), nThin));
    Theta = Theta(iThin, :);

    dta = Theta(:, 25);
    psi = Theta(:, 26);
    phi = Theta(:, 27);
    lgm = Theta(:, 28);
    cee = Theta(:, 29);
    sig = Theta(:, 30);
    eta = Theta(:, 31);
    lda = Theta(:, 32);
    iot = Theta(:, 33);

    rSig = zeros(nThin, 1);
    for i = 1:nThin
        rSig(i) = aqua_rsig_apatmar( ...
            dta(i), psi(i), phi(i), lgm(i), cee(i), ...
            sig(i), eta(i), lda(i), iot(i));
        disp(['Iteration: ', num2str(i), ' (', num2str(iThin(i)), ')']);
    end
end
