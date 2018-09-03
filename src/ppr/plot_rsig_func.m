%%
% File: plot_rsig_func.m
% Purpose:
% This script plots the signal ratio of the skewed-t conditional marginal
% models for various values of psi and phi.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   July 6, 2017
%%

% Override the subplot function
subplot = @(m, n, p)subaxis(m, n, p, ...
    'ML', 0.14, ...
    'MB', 0.17, ...
    'MR', 0.05, ...
    'MT', 0.04);

psi = -2:0.01:2;
rSig99 = aqua_rsig_sktmar(psi, 0.99 - psi);
rSig95 = aqua_rsig_sktmar(psi, 0.95 - psi);
rSig90 = aqua_rsig_sktmar(psi, 0.90 - psi);
rSig80 = aqua_rsig_sktmar(psi, 0.80 - psi);
rSig70 = aqua_rsig_sktmar(psi, 0.70 - psi);

figure();
subplot(1, 1, 1);
hold on;
plot(psi, rSig99, '-', 'LineWidth', 0.8);
plot(psi, rSig95, '-', 'LineWidth', 0.8);
plot(psi, rSig90, '-', 'LineWidth', 0.8);
plot(psi, rSig80, '-', 'LineWidth', 0.8);
plot(psi, rSig70, '-', 'LineWidth', 0.8);
axis([-2, 2, 0, 1]);
set(gca, 'ticklabelinterpreter', 'latex', 'fontsize', 11);
xlabel('$\psi$', 'interpreter', 'latex', 'fontsize', 13);
ylabel('$R_{\mathrm{Sig}}$', 'interpreter', 'latex', 'fontsize', 13);
h = legend( ...
    '$\gamma = 0.99$', ...
    '$\gamma = 0.95$', ...
    '$\gamma = 0.9$', ...
    '$\gamma = 0.8$', ...
    '$\gamma = 0.7$', ...
    'location', 'southeast');
set(h, 'interpreter', 'latex', 'fontsize', 11);

% Window setting
set(gcf, 'renderer', 'painters');
set(gcf, 'units', 'centimeters');
set(gcf, 'position', [0.5, 1.5, 11.5, 8]);

% Print setting
set(gcf, 'paperunits', 'centimeters');
set(gcf, 'paperpositionmode', 'manual');
set(gcf, 'paperposition', [0, 0, 11.5, 8]);
set(gcf, 'papertype', '<custom>');
set(gcf, 'papersize', [11.5, 8]);

% Print to PDF
print('rsig_func', '-dpdf');
