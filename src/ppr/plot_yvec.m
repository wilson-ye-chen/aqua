%%
% File: plot_yvec.m
% Purpose:
% Illustration diagram of constructing the y-vectors.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   June 1, 2017
%%

% Override the subplot function
subplot = @(m, n, p)subaxis(m, n, p, ...
    'ML', 0.02, ...
    'MB', 0.22, ...
    'MR', 0.02, ...
    'MT', 0.07);

n = 10;
s = [1, 2, 4, 1, 3];
ZMat = normrnd(0, 1, n, 5);
YMat = repmat(s, n, 1) .* ZMat;

figure();
subplot(1, 1, 1);
plot(YMat(:), '-k', 'linewidth', 1.0);
hold on;
for i = 10.5:10:40.5
    plot([i, i], [-10, 10], '--k', 'linewidth', 1.0);
end
axis([0.5, 50.5, -10, 10]);
set(gca, 'ticklabelinterpreter', 'latex', 'fontsize', 13);
set(gca, 'xtick', [5.5, 15.5, 25.5, 35.5, 45.5]);
set(gca, 'xticklabel', { ...
    '$\mathbf{y}_{1}$', ...
    '$\mathbf{y}_{2}$', ...
    '$\mathbf{y}_{3}$', ...
    '$\mathbf{y}_{4}$', ...
    '$\mathbf{y}_{5}$'});
set(gca, 'ytick', []);

% Window setting
set(gcf, 'renderer', 'painters');
set(gcf, 'units', 'centimeters');
set(gcf, 'position', [1, 1, 13, 3.5]);

% Print setting
set(gcf, 'paperunits', 'centimeters');
set(gcf, 'paperpositionmode', 'manual');
set(gcf, 'paperposition', [0, 0, 13, 3.5]);
set(gcf, 'papertype', '<custom>');
set(gcf, 'papersize', [13, 3.5]);

% Print to PDF
print('yvec', '-dpdf');
