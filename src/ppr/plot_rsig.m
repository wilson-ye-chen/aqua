%%
% File: plot_rsig.m
% Purpose:
% Plot the signal ratios of each margin for all indices.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   June 25, 2017
%%

% Override the subplot function
subplot = @(m, n, p)subaxis(m, n, p, ...
    'ML', 0.21, ...
    'MB', 0.19, ...
    'MR', 0.03, ...
    'MT', 0.03);

% Generate table
T = table_rsig('result');

% For each margin
for i = 1:4
    m = (i - 1) .* 3 + 1;
    l = (i - 1) .* 3 + 2;
    u = (i - 1) .* 3 + 3;
    figure();
    subplot(1, 1, 1);
    hold on;

    % For each data
    for j = 1:10
        plot(j, T(m, j), '.k', 'markersize', 8);
        plot([j, j], [T(l, j), T(u, j)], '-k', 'linewidth', 0.8);
        axis([0.5, 10.5, -0.03, 1.03]);
        set(gca, 'xtick', 1:10);
        set(gca, 'ticklabelinterpreter', 'latex', 'fontsize', 11);
        xlabel('Data', 'interpreter', 'latex', 'fontsize', 13);
        ylabel('Signal ratio', 'interpreter', 'latex', 'fontsize', 13);
    end

    % Window setting
    set(gcf, 'renderer', 'painters');
    set(gcf, 'units', 'centimeters');
    set(gcf, 'position', [0.5, 1.5, 7, 7]);

    % Print setting
    set(gcf, 'paperunits', 'centimeters');
    set(gcf, 'paperpositionmode', 'manual');
    set(gcf, 'paperposition', [0, 0, 7, 7]);
    set(gcf, 'papertype', '<custom>');
    set(gcf, 'papersize', [7, 7]);

    % Print to PDF
    print(['rsig_', num2str(i)], '-dpdf');
end
