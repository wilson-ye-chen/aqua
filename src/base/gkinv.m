function Q = gkinv(U, Abgk, c)
% Q = gkinv(U, Abgk, c) evaluates the quantile function (inverse
% cdf) of the g-and-k distribution. U, Abgk, and c all must have
% the same number of rows.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   February 9, 2016

    n = size(U, 2);
    A = repmat(Abgk(:, 1), 1, n);
    B = repmat(Abgk(:, 2), 1, n);
    G = repmat(Abgk(:, 3), 1, n);
    K = repmat(Abgk(:, 4), 1, n);
    C = repmat(c, 1, n);
    
    Z = norminv(U, 0, 1);
    Gz = 1 + C .* (1 - exp(-G .* Z)) ./ (1 + exp(-G .* Z));
    Kz = (1 + Z .^ 2) .^ K;
    Q = A + B .* Gz .* Kz .* Z;
end
