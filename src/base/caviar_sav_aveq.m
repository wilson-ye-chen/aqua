function qAve = caviar_sav_aveq(Theta, y, q0)
% qAve = caviar_sav_aveq(Theta, y, q0) computes the conditional quantiles by
% averaging over those given by the CAViaR-SAV model with parameters sampled
% from the posterior distribution.
%
% Input:
% Theta    - matrix of observed parameter vectors, where each row is an
%            observation, and each column is a parameter.
% y        - vector of observations.
% q0       - quantile of the first period.
%
% Output:
% qAve     - vector of average conditional quantiles, containing one more
%            element than the number of observations, where the last element
%            is the out-of-sample one-period-ahead forecast.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   September 5, 2015

    nObs = numel(y);
    nTheta = size(Theta, 1);
    
    qSum = zeros(nObs + 1, 1);
    for i = 1:nTheta
        b1 = Theta(i, 1);
        b2 = Theta(i, 2);
        b3 = Theta(i, 3);
        q = caviar_sav_q(b1, b2, b3, q0, y);
        qSum = qSum + q;
    end
    qAve = qSum ./ nTheta;
end
