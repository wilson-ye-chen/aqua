function [nObs, nGap, maxC, nOut, maxS, p, T, D, iD] = genstats( ...
    file, timerule, cTol, sTol)
% [nObs, nGap, maxC, nOut, maxS, p, T, D, iD] = genstats(file, ...
% timerule, cTol, sTol) imports the raw CSV data files from TRTH,
% and generates the summary statistics relevant to data cleaning.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   June 6, 2016

    % Import 1-minute data
    raw = importdata(file);
    date = raw.textdata(2:end, 2);
    time = raw.textdata(2:end, 3);
    offset = zeros(size(raw.data));
    last = raw.data;
    [p, T, D, iD] = import1min(date, time, offset, last, timerule);
    
    % Generate the summary statistics
    [nObs, nGap, maxC, nOut, maxS] = price2stats(p, iD, cTol, sTol);
end
