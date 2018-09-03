%%
% File: plot_w.m
% Purpose:
% This script plots the posterior mean estimates of the conditional weights
% of the Apatosaurus marginal model.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   August 29, 2017
%%

% Override the subplot function
subplot = @(m, n, p)subaxis(m, n, p, ...
    'ML', 0.09, ...
    'MB', 0.1, ...
    'MR', 0.09, ...
    'MT', 0.05);

load('result/estresult_aqua_spx.mat');

dn = datenum(D);
figure();
subplot(1, 1, 1);
yyaxis left;
plot(dn, wAve, '-');
axis([dn(1), dn(end), 0.82, 1]);
ylabel('$w_{t}$', 'interpreter', 'latex', 'fontsize', 13);
yyaxis right;
plot(dn, Xi(:, 4), '.');
axis([dn(1), dn(end), 0, 0.7]);
ylabel('$\xi_{4,t}$', 'interpreter', 'latex', 'fontsize', 13);
datetick('x', 'yyyy', 'keeplimits');
set(gca, 'ticklabelinterpreter', 'latex', 'fontsize', 11);

% Window setting
set(gcf, 'renderer', 'painters');
set(gcf, 'units', 'centimeters');
set(gcf, 'position', [0.5, 1.5, 19, 8]);

% Print setting
set(gcf, 'paperunits', 'centimeters');
set(gcf, 'paperpositionmode', 'manual');
set(gcf, 'paperposition', [0, 0, 19, 8]);
set(gcf, 'papertype', '<custom>');
set(gcf, 'papersize', [19, 8]);

% Print to PDF
print('w', '-dpdf');
