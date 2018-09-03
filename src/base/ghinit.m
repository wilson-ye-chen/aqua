function gh = ghinit(x, flag)
% gh = ghinit(x, flag) computes the initial values of the g-and-h
% parameters by exploiting the relationships between the parameters and
% quantile based measures of location, scale, skewness, and kurtosis.
% This function returns initial values of all four parameters when flag
% is set to 1, and returns initial values of only g and h when flag is
% set to 2. This function is not designed to accurately estimate the g-
% and-h parameters, and therefore is only suitable for providing initial
% guesses for other more costly optimisation algorithms.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   March 22, 2015

    if flag == 1
        q = quantile(x, [0.25, 0.5, 0.75]);
        a = q(2);
        b = 0.64 .* (q(3) - q(1));
    elseif flag == 2
        a = [];
        b = [];
    else
        error('Invalid flag.');
        gh = [];
        return
    end
    f = @(u)quantile(x, u);
    g = clamp(3.03 .* skew_galton(f), -1, 1);
    h = clamp(0.86 .* kurt_moors(f) - 1.06, 0, 1);
    gh = [a, b, g, h];
end
