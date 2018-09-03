function logPost = caviar_sav_post(b1, b2, b3, q0, nPre, y, u)
% logPost = caviar_sav_post(b1, b2, b3, q0, nPre, y, u) evaluates the log
% posterior of the symmetric absolute value CAViaR model, where the likelihood
% function is the asymmetric Laplace density and the prior is proportional to
% one over the scale parameter of the ALD. The scale parameter is integrated
% out of the posterior.
%
% Input:
% b1      - constant parameter.
% b2      - coefficient of the recursive term.
% b3      - coefficient of the absolute value term.
% q0      - initial value of the conditional quantile recursions.
% nPre    - number of pre-samples; number of observations at the start of the
%           recursions ignored by the posterior calculation.
% y       - vector of observed responses.
% u       - scalar in (0, 1) setting the quantile level.
%
% Output:
% logPost - value of the log posterior.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   September 5, 2015

    if b2 < 0 || b2 >= 1
        logPost = -inf;
        return
    end
    
    n = numel(y) - nPre;
    q = caviar_sav_q(b1, b2, b3, q0, y);
    e = y((nPre + 1):end) - q((nPre + 1):(end - 1));
    logPost = -n .* log(sum(loss(e, u)));
end

function rho = loss(e, u)
    rho = 0.5 .* (abs(e) + (2 .* u - 1) .* e);
end
