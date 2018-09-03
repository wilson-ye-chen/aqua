n = 2^10;
x = linspace(0,100,n);
f = cos(x/10)+(x/50).^2;
y0 = f + randn(size(x))/10;
y = y0;

% this adds outliers to the signal y
range = n/2:10:3*n/4;
y(range) = min(rand(size(range))*10 + y(range), 10);

s = 5000;
l = 1;
nIter = 5000;
tic;
[z, error] = l1spline(y, s, l, nIter, 1, 1e-5);
toc;

figure,
plot(error,'LineWidth',2);
xlabel('Iterations');
ylabel('Error');

figure;
plot(x,y,'g',x,z,'b','LineWidth',2);
axis square, title('L1 spline');