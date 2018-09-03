%%
% File: plot_apat.m
% Purpose:
% Plots the density and distribution functions of the Apatosaurus
% distribution for mu = 0.3 and mu = 0.7.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   July 8, 2017
%%

% Override the subplot function
subplot = @(m, n, p)subaxis(m, n, p, ...
    'ML', 0.21, ...
    'MB', 0.18, ...
    'MR', 0.06, ...
    'MT', 0.06);

% Values of PDF and CDF
x = 0:0.01:2.5;
pdf1 = apatpdf(x, 0.3, 0.6, 3, 0.2, 0.02, 0.9);
pdf2 = apatpdf(x, 0.7, 0.6, 3, 0.2, 0.02, 0.9);
cdf1 = apatcdf(x, 0.3, 0.6, 3, 0.2, 0.02, 0.9);
cdf2 = apatcdf(x, 0.7, 0.6, 3, 0.2, 0.02, 0.9);

% Generate plots
for i = 1:2
    if i == 1
        y1 = pdf1;
        y2 = pdf2;
        yLim = [0, 4];
        name = 'apat_pdf.pdf';
        ylab = '$f_{\mathrm{Apat}}(h)$';
    else
        y1 = cdf1;
        y2 = cdf2;
        yLim = [0, 1];
        name = 'apat_cdf.pdf';
        ylab = '$F_{\mathrm{Apat}}(h)$';
    end

    figure();
    subplot(1, 1, 1);
    plot(x, y1, '-k', 'linewidth', 0.8);
    hold on;
    plot(x, y2, '--k', 'linewidth', 0.8);
    axis([0, 2.5, yLim]);
    set(gca, 'ticklabelinterpreter', 'latex', 'fontsize', 11);
    xlabel('$h$', 'interpreter', 'latex', 'fontsize', 13);
    ylabel(ylab, 'interpreter', 'latex', 'fontsize', 13);

    % Legend on the PDF only
    if i == 1
        l = legend( ...
            '$\mu = 0.3$', ...
            '$\mu = 0.7$', ...
            'location', 'northeast');
        set(l, 'interpreter', 'latex', 'fontsize', 11);
        legend boxoff;
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
    print(name, '-dpdf');
end
