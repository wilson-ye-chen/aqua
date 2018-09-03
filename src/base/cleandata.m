function [p_, T_, iD_, iDKeep, stat] = cleandata(p, T, D, iD, filterrule)
% [p_, T_, iD_, iDKeep, stat] = cleandata(p, T, D, iD, filterrule) cleans
% the data via filterrule.
%
% Input:
% p          - vector of intra-daily prices.
% T          - matrix of timestamps.
% D          - matrix of date-vectors.
% iD         - vector of row indices of the D matrix.
% filterrule - function handle to filter rule used.
%
% Output:
% p_         - vector of cleaned intra-daily prices.
% T_         - matrix of timestamps of cleaned prices.
% iD_        - vector of day-indices of cleaned prices.
% iDKeep     - binary vector where a zero indicates a removed day.
% stat       - vector of cleaning summary: (nD, nDDel, nP, nPDel, fPDel).
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   June 10, 2017

    nD = size(D, 1);
    nP = numel(p);
    iDKeep = false(nD, 1);
    iPKeep = false(nP, 1);
    for i = 1:nD
        iP = find(iD == i);
        pD = p(iP);
        [iDKeep(i), iPd] = filterrule(pD);
        iPKeep(iP(iPd)) = true;
    end
    p_ = p(iPKeep);
    T_ = T(iPKeep, :);
    iD_ = iD(iPKeep);

    % Summary stats
    nDDel = nD - sum(iDKeep);
    nPDel = nP - sum(iPKeep);
    fPDel = nPDel ./ nP .* 100;
    stat = [nD, nDDel, nP, nPDel, fPDel];

    disp(['Removed ', ...
        num2str(fPDel), '% of data (', ...
        num2str(nPDel), ' observations), including ', ...
        num2str(nDDel), ' full-days.']);
end
