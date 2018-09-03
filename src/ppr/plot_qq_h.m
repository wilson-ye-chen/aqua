%%
% File: plot_qq_h.m
% Purpose:
% QQ-plots of probability inverse transforms of the the h margin by both
% Apatosaurus and truncated-skewed-t models.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   June 29, 2017
%%

% Override the subplot function
subplot = @(m, n, p)subaxis(m, n, p, ...
    'ML', 0.2, ...
    'MB', 0.2, ...
    'MR', 0.03, ...
    'MT', 0.03);

% Load estimation results
load('result/estresult_h_spx.mat');

% Generate QQ-plots
for i = 1:2
    if i == 1
        z = zTrSkt;
        name = 'qq_h_trskt.pdf';
        ylab = '$Z(u_{\mathrm{TrSkt}, t})$';
    else
        z = zApat;
        name = 'qq_h_apat.pdf';
        ylab = '$Z(u_{\mathrm{Apat}, t})$';
    end

    [qf, qx, u] = myqqplot(@(u)norminv(u, 0, 1), z);
    xMin = min(qf);
    xMax = max(qf);
    xGap = 0.21 .* (xMax - xMin);
    lLim = xMin - xGap;
    uLim = xMax + xGap;
    figure();
    subplot(1, 1, 1);
    plot([lLim, uLim], [lLim, uLim], '--r', 'linewidth', 0.8);
    hold on;
    plot(qf, qx, '.b');
    axis([lLim, uLim, lLim, uLim]);
    set(gca, 'ticklabelinterpreter', 'latex', 'fontsize', 11);
    xlabel('Std.~normal quantiles', 'interpreter', 'latex', 'fontsize', 13);
    ylabel(ylab, 'interpreter', 'latex', 'fontsize', 13);

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
