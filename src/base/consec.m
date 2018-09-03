function [n, a, b] = consec(v)
% [n, a, b] = consec(v) finds all the sub-vectors of consecutive ones
% in a binary vector.
%
% Input:
% v - a binary vector.
%
% Output:
% n - vector of sub-vector lengths.
% a - vector of starting indices.
% b - vector of ending indices.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   June 1, 2016

    d = diff([0, v(:)', 0]);
    a = find(d == 1);
    b = find(d == -1) - 1;
    n = b - a + 1;
end
