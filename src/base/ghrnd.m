function Y = ghrnd(gh, m, n)
% Y = ghrnd(gh, m, n) generates random numbers from a g-and-h distribution.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   March 17, 2015

    U = unifrnd(0, 1, m, n);
    Y = ghinv(U, repmat(gh, m));
end
