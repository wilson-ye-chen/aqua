function [A, B, G, H, C] = aqua_postsumm(Theta)
% [A, B, G, H, C] = aqua_postsumm(Theta) summarises the posterior
% estimates of the AQUA-gh-tc model using a MCMC output, and arranges
% the results into tables.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   June 24, 2017

    A = zeros(3, 8);
    B = zeros(3, 8);
    G = zeros(3, 8);
    H = zeros(3, 9);
    C = zeros(3, 7);

    % Column indices
    iA = 1:8;
    iB = 9:16;
    iG = 17:24;
    iH = 25:33;
    iC = 34:40;

    % Means
    A(1, :) = mean(Theta(:, iA), 1);
    B(1, :) = mean(Theta(:, iB), 1);
    G(1, :) = mean(Theta(:, iG), 1);
    H(1, :) = mean(Theta(:, iH), 1);
    C(1, :) = mean(Theta(:, iC), 1);

    % Quantiles at level 0.025
    A(2, :) = quantile(Theta(:, iA), 0.025, 1);
    B(2, :) = quantile(Theta(:, iB), 0.025, 1);
    G(2, :) = quantile(Theta(:, iG), 0.025, 1);
    H(2, :) = quantile(Theta(:, iH), 0.025, 1);
    C(2, :) = quantile(Theta(:, iC), 0.025, 1);

    % Quantiles at level 0.975
    A(3, :) = quantile(Theta(:, iA), 0.975, 1);
    B(3, :) = quantile(Theta(:, iB), 0.975, 1);
    G(3, :) = quantile(Theta(:, iG), 0.975, 1);
    H(3, :) = quantile(Theta(:, iH), 0.975, 1);
    C(3, :) = quantile(Theta(:, iC), 0.975, 1);
end
