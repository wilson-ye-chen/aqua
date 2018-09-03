function [qf, qx, u, rD, gh] = getqq(dv, key, dataDir)
% [qf, qx, u, rD, gh] = getqq(dv, key, dataDir) generates a QQ-plot for a given
% date-vector of the form (year, month, day).
%
% Input:
% dv      - date-vector of the form (year, month, day).
% key     - data identifier.
% dataDir - directory where both pricedata_key and data_key files are found.
%
% Output:
% qf      - vector of population quantiles.
% qx      - vector of sample quantiles.
% u       - row vector of quantile levels used.
% rD      - vector of intra-daily returns.
% gh      - vector of g-and-h parameters.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   June 12, 2017

    pricedata = [dataDir, '/pricedata_', key, '.mat'];
    data = [dataDir, '/data_', key, '.mat'];
    load(pricedata);
    rD = getret(dv, p, D, iD);
    load(data);
    gh = getgh(dv, D, Xi);
    [qf, qx, u] = myqqplot(@(u)ghinv(u, gh), rD);
end
