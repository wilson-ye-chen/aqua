function Q = ghinv(U, Gh)
% Q = ghinv(U, Gh) evaluates the quantile function (inverse
% cdf) of the g-and-h distribution. U and Gh must have the
% same number of rows.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   October 27, 2014

    i1 = logical(Gh(:, 3));
    i0 = ~i1;
    [m, n] = size(U);
    
    % Rows with non-zero g's
    A1 = repmat(Gh(i1, 1), 1, n);
    B1 = repmat(Gh(i1, 2), 1, n);
    G1 = repmat(Gh(i1, 3), 1, n);
    H1 = repmat(Gh(i1, 4), 1, n);
    Z1 = norminv(U(i1, :), 0, 1);
    
    % Rows with zero g's
    A0 = repmat(Gh(i0, 1), 1, n);
    B0 = repmat(Gh(i0, 2), 1, n);
    G0 = repmat(Gh(i0, 3), 1, n);
    H0 = repmat(Gh(i0, 4), 1, n);
    Z0 = norminv(U(i0, :), 0, 1);
    
    Q = zeros(m, n);
    Q(i1, :) = A1 + B1 .* (exp(G1 .* Z1) - 1) ./ G1 .* ...
        exp(H1 .* Z1 .^ 2 ./ 2);
    Q(i0, :) = A0 + B0 .* Z0 .* exp(H0 .* Z0 .^ 2 ./ 2);
end
