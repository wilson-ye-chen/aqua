function [B1, B2, D] = syncdate(D1, A1, D2, A2)
% [B1, B2, D] = syncdate(D1, A1, D2, A2) synchronises the rows of two
% matrices according to their dates. Only those rows with common dates
% are kept and matched.
%
% Input:
% D1 - matrix of date vectors corresponding to A1.
% A1 - the first matrix. It must have the same number of rows as D1.
% D2 - matrix of date vectors corresponding to A2.
% A2 - the second matrix. It must have the same number of rows as D2.
%
% Output:
% B1 - synchronised A1.
% B2 - synchronised A2.
% D  - synchronised date vectors.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   July 7, 2015

    [D, i1, i2] = intersect(D1, D2, 'rows', 'stable');
    B1 = A1(i1, :);
    B2 = A2(i2, :);
end
