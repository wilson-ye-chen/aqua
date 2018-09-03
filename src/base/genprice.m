function [p, T, D, iD, iDKeep, stat] = genprice(file1min, timerule)
% [p, T, D, iD, iDKeep, stat] = genprice(file1min, timerule) imports the raw
% CSV data files from Thomson Reuters, and generates the cleaned price vector
% for empirical studies.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   June 9, 2017

    % Import 1-minute data
    raw = importdata(file1min);
    date = raw.textdata(2:end, 2);
    time = raw.textdata(2:end, 3);
    offset = zeros(size(raw.data));
    last = raw.data;
    [p, T, D, iD] = import1min(date, time, offset, last, timerule);

    % Clean data
    [p, T, iD, iDKeep, stat] = cleandata(p, T, D, iD, @filterrule_1min);
end
