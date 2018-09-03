function rD = getret(dv, p, D, iD)
% rD = getret(dv, p, D, iD) creates a vector of log percentage returns
% for a given date-vector of the form (year, month, day).
%
% Input:
% dv - date-vector of the form (year, month, day).
% p  - vector of intra-daily prices.
% D  - matrix of date-vectors.
% iD - vector of row indices of the D matrix.
%
% Output:
% rD - vector of log percentage returns.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   June 10, 2017

    i = find(D(:, 1) == dv(1) & D(:, 2) == dv(2) & D(:, 3) == dv(3));
    pD = p(iD == i);
    rD = diff(log(pD)) .* 100;
end
