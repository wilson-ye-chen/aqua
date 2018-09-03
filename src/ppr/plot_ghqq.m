%%
% File: plot_ghqq.m
% Purpose:
% QQ-plots against fitted g-and-h quantiles for S&P 500 1-minute returns
% of three specific days: 31-Dec-2009, 6-May-2010, and 4-Apr-2014.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   June 12, 2017
%%

% Override the subplot function
subplot = @(m, n, p)subaxis(m, n, p, ...
    'ML', 0.25, ...
    'MB', 0.2, ...
    'MR', 0.03, ...
    'MT', 0.03);

dv1 = [2009, 12, 31];
dv2 = [2010, 5, 6];
dv3 = [2014, 4, 4];
D = [dv1; dv2; dv3];

for i = 1:3
    [qf, qx, u, ~, gh] = getqq(D(i, :), 'spx', './mat');
    xMin = min(qf);
    xMax = max(qf);
    xGap = 0.1 .* (xMax - xMin);
    lLim = xMin - xGap;
    uLim = xMax + xGap;
    figure();
    subplot(1, 1, 1);
    plot([lLim, uLim], [lLim, uLim], '--r', 'linewidth', 0.8);
    hold on;
    plot(qf, qx, '.b');
    axis([lLim, uLim, lLim, uLim]);
    set(gca, 'ticklabelinterpreter', 'latex', 'fontsize', 11);
    xlabel('g-and-h quantiles', 'interpreter', 'latex', 'fontsize', 13);
    ylabel('Sample quantiles', 'interpreter', 'latex', 'fontsize', 13);

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
    name = ['ghqq_', ...
        num2str(D(i, 1)), '-', ...
        num2str(D(i, 2)), '-', ...
        num2str(D(i, 3))];
    print(name, '-dpdf');
end
