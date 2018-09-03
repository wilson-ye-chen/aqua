function gh = getgh(dv, D, Xi)
% gh = getgh(dv, D, Xi) looks up the vector of g-and-h parameters for a
% given date-vector of the form (year, month, day).
%
% Input:
% dv - date-vector of the form (year, month, day).
% D  - matrix of date-vectors corresponding to Xi.
% Xi - matrix of g-and-h parameters (a, b*, g, h), where b* = log(b).
%
% Output:
% gh - vector of g-and-h parameters (a, b, g, h).
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   June 12, 2017

    i = find(D(:, 1) == dv(1) & D(:, 2) == dv(2) & D(:, 3) == dv(3));
    gh = [Xi(i, 1), exp(Xi(i, 2)), Xi(i, 3), Xi(i, 4)];
end
