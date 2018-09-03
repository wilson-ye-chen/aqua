%%
% File: plot_var.m
% Purpose:
% This script plots the Bayesian 1-day-ahead VaR forecasts made by
% the gh-AQUA-tc model.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   August 27, 2017
%%

% Override the subplot function
subplot = @(m, n, p)subaxis(m, n, p, ...
    'ML', 0.1, ...
    'MB', 0.08, ...
    'MR', 0.05, ...
    'MT', 0.03);

colorData = [0.7, 0.7, 0.7];
colorVar5 = [0.3, 0.3, 1];
colorVar1 = [1, 0.3, 0.3];

load('mat/data_spx.mat');
load('result/aqua.spx.3051-5084.mat');

dn = datenum(DFore);
figure();
subplot(1, 1, 1);
plot(dn, r(3051:5084), '.', 'color', colorData, 'markersize', 9);
hold on;
plot(dn, var5, '-', 'color', colorVar5, 'linewidth', 0.9);
plot(dn, var1, '-', 'color', colorVar1, 'linewidth', 0.9);
axis([dn(1), dn(end), -18, 12]);
datetick('x', 'yyyy', 'keeplimits');
set(gca, 'ticklabelinterpreter', 'latex', 'fontsize', 11);
ylabel('$q^{\mathrm{D}}_{u,t}$', 'interpreter', 'latex', 'fontsize', 13);

% Window setting
set(gcf, 'renderer', 'painters');
set(gcf, 'units', 'centimeters');
set(gcf, 'position', [0.5, 1.5, 17, 10]);

% Print setting
set(gcf, 'paperunits', 'centimeters');
set(gcf, 'paperpositionmode', 'manual');
set(gcf, 'paperposition', [0, 0, 17, 10]);
set(gcf, 'papertype', '<custom>');
set(gcf, 'papersize', [17, 10]);

% Print to PDF
print('var', '-dpdf');
