function wAve = aqua_avew(Theta, mu0, xi4)
% wAve = aqua_avew(Theta, mu0, xi4) computes the conditional weight estimates
% by averaging over those given by the sampled parameters from the posterior
% distribution.
%
% Input:
% Theta - matrix of sampled parameter vectors, where each row corresponds to
%         an observation and each column corresponds to a parameter.
% mu0   - initial value of the conditional mode recursion.
% xi4   - vector of observed values of h.
%
% Output:
% wAve  - vector of average conditional weights, containing one more element
%         than the number of observed parameter vectors, where the last
%         element is the out-of-sample one-period-ahead forecast.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   May 29, 2017

    delta   = Theta(:, 25);
    psi     = Theta(:, 26);
    phi     = Theta(:, 27);
    lnGamma = Theta(:, 28);
    c       = Theta(:, 29);
    gamma   = exp(lnGamma);

    nTheta = size(Theta, 1);
    nObs = numel(xi4);
    wSum = zeros(nObs + 1, 1);
    for i = 1:nTheta
        mu = aqua_mu(delta(i), psi(i), phi(i), mu0, xi4);
        w = 0.5 + 0.5 ./ (1 + exp(-gamma(i) .* (mu - c(i))));
        wSum = wSum + w;
    end
    wAve = wSum ./ nTheta;
end
