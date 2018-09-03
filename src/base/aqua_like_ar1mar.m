function logLike = aqua_like_ar1mar(delta, psi, sigma, mu0, nPre, xi)
% logLike = aqua_like_ar1mar(delta, psi, sigma, mu0, nPre, xi) computes the
% log-likelihood of the Gaussian-AR(1) marginal model for an AQUA model.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   May 1, 2018

    % Stationarity
    if psi <= -1 || psi >= 1
        logLike = -inf;
        return
    end

    % Positivity
    if sigma <= 0
        logLike = -inf;
        return
    end

    % Compute the conditional means
    xi = xi(:);
    mu = [mu0; delta + psi .* xi(1:(end - 1))];

    % Compute the log-likelihood
    xi = xi((nPre + 1):end);
    mu = mu((nPre + 1):end);
    logLike = sum(log(normpdf(xi, mu, sigma)));
end
