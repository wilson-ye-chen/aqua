function muAve = margin_avemu_trskt(Theta, mu0, xi4)
% muAve = margin_avemu_trskt(Theta, mu0, xi4) computes the conditional mode
% estimates by averaging over those given by the sampled parameters from
% the posterior distribution.
%
% Input:
% Theta - matrix of sampled parameter vectors, where each row corresponds to
%         an observation and each column corresponds to a parameter.
% mu0   - initial value of the conditional mode recursion.
% xi4   - vector of observed values of h.
%
% Output:
% muAve - vector of average conditional modes, containing one more element
%         than the number of observed parameter vectors, where the last
%         element is the out-of-sample one-period-ahead forecast.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   June 21, 2017

    dta = Theta(:, 1);
    psi = Theta(:, 2);
    phi = Theta(:, 3);

    nTheta = size(Theta, 1);
    nObs = numel(xi4);
    muSum = zeros(nObs + 1, 1);
    for i = 1:nTheta
        mu = aqua_mu(dta(i), psi(i), phi(i), mu0, xi4);
        muSum = muSum + mu;
    end
    muAve = muSum ./ nTheta;
end
