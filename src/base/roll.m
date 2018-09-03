function W = roll(x, l)
% W = roll(x, l) returns a matrix of subvectors by applying a rolling
% window to the input vector.
%
% Input:
% x - vector to be rolled.
% l - window length.
%
% Output:
% W - matrix of rolled vector where each row is a subvector.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   August 27, 2015

    nX = numel(x);
    nW = nX - l + 1;
    W = zeros(nW, l);
    for i = 1:nW
        W(i, :) = x(i:(i + l - 1));
    end
end
