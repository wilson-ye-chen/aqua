%%
% File: plot_s.m
% Purpose:
% This script plots the posterior mean of the scaling factor for the
% 1-day-ahead VaR forecasts made by the gh-AQUA-tc model.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   August 27, 2017
%%

% Override the subplot function
subplot = @(m, n, p)subaxis(m, n, p, ...
    'ML', 0.08, ...
    'MB', 0.15, ...
    'MR', 0.04, ...
    'MT', 0.07);

colorS5 = [0.3, 0.3, 1];
colorS1 = [1, 0.3, 0.3];

load('result/aqua.spx.3051-5084.mat');
dn = datenum(DFore);

% Generate plots
for i = 1:2
    if i == 1
        s = s5;
        c = colorS5;
        yLim = [31.8, 34.6];
        yLab = '$\hat{s}_{0.05}$';
        name = 's_5';
    else
        s = s1;
        c = colorS1;
        yLim = [26, 30.2];
        yLab = '$\hat{s}_{0.01}$';
        name = 's_1';
    end

    figure();
    subplot(1, 1, 1);
    plot(dn, s, '-', 'color', c, 'linewidth', 1.3);
    axis([dn(1), dn(end), yLim]);
    datetick('x', 'yyyy', 'keeplimits');
    set(gca, 'ticklabelinterpreter', 'latex', 'fontsize', 11);
    ylabel(yLab, 'interpreter', 'latex', 'fontsize', 13);

    % Window setting
    set(gcf, 'renderer', 'painters');
    set(gcf, 'units', 'centimeters');
    set(gcf, 'position', [0.5, 1.5, 17, 5]);

    % Print setting
    set(gcf, 'paperunits', 'centimeters');
    set(gcf, 'paperpositionmode', 'manual');
    set(gcf, 'paperposition', [0, 0, 17, 5]);
    set(gcf, 'papertype', '<custom>');
    set(gcf, 'papersize', [17, 5]);

    % Print to PDF
    print(name, '-dpdf');
end
