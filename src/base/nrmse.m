function val = nrmse(yRef, y)
% val = nrmse(yRef, y) computes the scale-invariant normalised RMSE.
% The arguments must either be scalars or vectors of the same size.
%
% Input:
% yRef - a vector (or a scalar) of reference observations.
% y    - a vector (or a scalar) of test observations.
%
% Output:
% val  - a scalar of the value of the loss function.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   February 23, 2016

    val = sqrt(mean((yRef - y) .^ 2)) ./ abs(mean(yRef));
end
