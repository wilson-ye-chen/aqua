%%
% File: plot_q1min.m
% Purpose:
% This script plots the estimates of the smoothed 1-minute quantiles
% estimated by the posterior mean with respect to the gh-AQUA-tc model.
% The quantile levels are [0.01, 0.05, 0.25, 0.5, 0.75, 0.95, 0.99].
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   August 29, 2017
%%

% Override the subplot function
subplot = @(m, n, p)subaxis(m, n, p, ...
    'ML', 0.1, ...
    'MB', 0.09, ...
    'MR', 0.06, ...
    'MT', 0.03);

load('result/estresult_aqua_spx.mat');

dn = datenum(D);
figure();
subplot(1, 1, 1);
plot(dn, QAve, '-');
axis([dn(1), dn(end), -0.7, 0.7]);
datetick('x', 'yyyy', 'keeplimits');
set(gca, 'ticklabelinterpreter', 'latex', 'fontsize', 11);
ylabel('$\tilde{X}_{t}(u)$', 'interpreter', 'latex', 'fontsize', 13);

% Window setting
set(gcf, 'renderer', 'painters');
set(gcf, 'units', 'centimeters');
set(gcf, 'position', [0.5, 1.5, 17, 9]);

% Print setting
set(gcf, 'paperunits', 'centimeters');
set(gcf, 'paperpositionmode', 'manual');
set(gcf, 'paperposition', [0, 0, 17, 9]);
set(gcf, 'papertype', '<custom>');
set(gcf, 'papersize', [17, 9]);

% Print to PDF
print('q1min', '-dpdf');
