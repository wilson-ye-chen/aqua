function cx = clamp(x, l, u)
% cx = clamp(x, l, u) implements the clamp function:
% cx = l if x < l,
% cx = u if x > u,
% cx = x otherwise.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   March 21, 2015

    cx = min(u, max(l, x));
end
