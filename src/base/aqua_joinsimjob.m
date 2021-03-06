function [iSamp, M, S, L, U, AccRate, MapcVal] = aqua_joinsimjob(dirName)
% [iSamp, M, S, L, U, AccRate, MapcVal] = aqua_joinsimjob(dirName) joins the
% result files in a single directory generated by the simulation jobs. The
% directory must contain only the result files.
%
% Input:
% dirName - directory name.
%
% Output:
% iSamp   - sample index.
% M       - matrix of posterior means.
% S       - matrix of posterior standard deviations.
% L       - matrix of the lower-bound of the 95-percent posterior interval.
% U       - matrix of the upper-bound of the 95-percent posterior interval.
% AccRate - matrix of acceptance rates.
% MapcVal - matrix of MAPC values.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   June 8, 2016

    nDim = 40;
    nBlock = 10;
    maxAdapt = 30;
    
    file = dir(dirName);
    nFile = numel(file) - 2;
    
    iSamp = zeros(nFile, 1);
    M = zeros(nFile, nDim);
    S = zeros(nFile, nDim);
    L = zeros(nFile, nDim);
    U = zeros(nFile, nDim);
    AccRate = zeros(nFile, nBlock);
    MapcVal = zeros(nFile, maxAdapt);
    
    for i = 1:nFile
        load([dirName, '/', file(i + 2).name]);
        iSamp(i) = idx;
        M(i, :) = mean(Theta, 1);
        S(i, :) = std(Theta, 0, 1);
        L(i, :) = quantile(Theta, 0.025, 1);
        U(i, :) = quantile(Theta, 0.975, 1);
        AccRate(i, :) = sum(Accept, 1) ./ size(Accept, 1);
        MapcVal(i, (1:numel(mapc))) = mapc;
        disp([file(i + 2).name, ' appended.']);
    end
    
    [iSamp, iSort] = sort(iSamp, 'ascend');
    M = M(iSort, :);
    S = S(iSort, :);
    L = L(iSort, :);
    U = U(iSort, :);
    AccRate = AccRate(iSort, :);
    MapcVal = MapcVal(iSort, :);
end
