y = imread('depth-000008.jp2');
y = double(y);
y(y > 60000) = NaN;

s = 0.02;
l = 1;
tic;
[z, ~] = l1spline(y, s, l, 100, 1, 1e-3);
toc;

Max = max([max(y(:)) max(z(:))]);
yDisp = y;
yDisp(~isfinite(y)) = Max + Max / 100;

Max = max([max(yDisp(:)) max(z(:))]);
Min = min([min(yDisp(:)) min(z(:))]);
clims = [Min, Max];

figure,

colordata = colormap(autumn);
colordata(end,:) = [0 0 0];
colormap(colordata);

subplot(131), imagesc(yDisp, clims); axis image; axis off;
title('Noisy corrupt data')
subplot(132), imagesc(z, clims); axis image; axis off;
title('L1 Recovered data')
subplot(133), imagesc(abs(y-z)); axis image; axis off;
title('Error')
