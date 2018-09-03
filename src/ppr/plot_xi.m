%%
% File: plot_xi.m
% Purpose:
% This script plots the estimates of a, log(b), g, and h from the S&P 500
% index, overlaid by the corresponding smoothed signals estimated by the
% posterior mean with respect to the gh-AQUA-tc model.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   June 24, 2017
%%

% Override the subplot function
subplot = @(m, n, p)subaxis(m, n, p, ...
    'ML', 0.07, ...
    'MB', 0.15, ...
    'MR', 0.02, ...
    'MT', 0.07);

colorData = [0.7, 0.7, 0.7];
colorSign = [0.85, 0, 0];
YLim = [ ...
    -0.023, 0.023; ...
    -6, 0; ...
    -0.55, 0.55; ...
    0, 0.6];
pdfName = {'xi_1', 'xi_2', 'xi_3', 'xi_4'};

% Estimation result
load('result/estresult_aqua_spx.mat');

dn = datenum(D);
for i = 1:4
    figure();
    subplot(1, 1, 1);
    plot(dn, Xi(:, i), '.', 'color', colorData);
    hold on;
    plot(dn, MAve(:, i), '-', 'color', colorSign);
    axis([dn(1), dn(end), YLim(i, :)]);
    datetick('x', 'yyyy', 'keeplimits');
    set(gca, 'ticklabelinterpreter', 'latex', 'fontsize', 11);

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
    print(pdfName{i}, '-dpdf');
end
