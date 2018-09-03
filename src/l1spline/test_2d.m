% 2-D example with missing data
n = 256;
y0 = peaks(n);
y = y0 + randn(size(y0))*2;

maxY = max(y(:));
I = randperm(n^2);
range = 1:n^2*0.3;
y(I(range)) = rand(size(range))*maxY*10;

tic;
[z, error] = l1spline(y, 100, 1, 100, 1, 1e-5);
toc;

figure,
subplot(131), imagesc(y), axis equal off
title('Noisy corrupt data')
subplot(132), imagesc(z), axis equal off
title('L1 Recovered data ...')
subplot(133), imagesc(y0), axis equal off
title('... compared with original data')
