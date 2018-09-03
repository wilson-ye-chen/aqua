function [A, B, G, H, C] = aqua_simsumm(M)
% [A, B, G, H, C] = aqua_simsumm(M) summarises the results of the
% simulation study of the AQUA-gh-tc model, and arranges the results
% into tables. At the moment, only posterior means are considered.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   May 24, 2017

    A = zeros(4, 8);
    B = zeros(4, 8);
    G = zeros(4, 8);
    H = zeros(4, 9);
    C = zeros(4, 7);

    % Column indices
    iA = 1:8;
    iB = 9:16;
    iG = 17:24;
    iH = 25:33;
    iC = 34:40;

    % True values
    A(1, :) = [0, 0.06, 0.91, 6e-8, 0.15, 0.84, 8, -0.16];
    B(1, :) = [-0.13, 0.43, 0.53, 5e-3, 0.06, 0.88, 15, 0];
    G(1, :) = [0, 0.05, 0.93, 7e-5, 0.07, 0.92, 18, 0.14];
    H(1, :) = [3e-3, 0.22, 0.74, 3.7, 0.03, 0.06, 6, 0.15, 1e-4];
    C(1, :) = [-0.3, -0.1, 0.2, -0.22, -0.6, 0.12, 15];

    % Means
    A(2, :) = mean(M(:, iA), 1);
    B(2, :) = mean(M(:, iB), 1);
    G(2, :) = mean(M(:, iG), 1);
    H(2, :) = mean(M(:, iH), 1);
    C(2, :) = mean(M(:, iC), 1);

    % Quantiles at level 0.025
    A(3, :) = quantile(M(:, iA), 0.025, 1);
    B(3, :) = quantile(M(:, iB), 0.025, 1);
    G(3, :) = quantile(M(:, iG), 0.025, 1);
    H(3, :) = quantile(M(:, iH), 0.025, 1);
    C(3, :) = quantile(M(:, iC), 0.025, 1);

    % Quantiles at level 0.975
    A(4, :) = quantile(M(:, iA), 0.975, 1);
    B(4, :) = quantile(M(:, iB), 0.975, 1);
    G(4, :) = quantile(M(:, iG), 0.975, 1);
    H(4, :) = quantile(M(:, iH), 0.975, 1);
    C(4, :) = quantile(M(:, iC), 0.975, 1);
end
