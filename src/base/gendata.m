function [D, Xi, logX, r, stat] = gendata(file1min, fileEod, timerule)
% [D, Xi, logX, r, stat] = gendata(file1min, fileEod, timerule) imports the
% raw CSV data files from Thomson Reuters, and generates the appropriate data
% arrays for empirical studies.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   June 11, 2017

    % Import 1-minute data
    raw = importdata(file1min);
    date = raw.textdata(2:end, 2);
    time = raw.textdata(2:end, 3);
    offset = zeros(size(raw.data));
    last = raw.data;
    [p, T, D1min, iD] = import1min(date, time, offset, last, timerule);

    % Clean data
    [p, ~, iD, ~, stat] = cleandata(p, T, D1min, iD, @filterrule_1min);

    % Fit the g-and-h distributions
    Gh = price2gh(p, D1min, iD);
    Xi = [Gh(:, 1), log(Gh(:, 2)), Gh(:, 3), Gh(:, 4)];

    % Compute the log-RV using 1-minute data
    [rv, iDKeep] = price2rv(p, D1min, iD);
    logX = log(rv);

    % Remove the rows corresponding to empty days.
    D1min = D1min(iDKeep, :);

    % Import EOD data
    raw = importdata(fileEod);
    date = raw.textdata(3:end, 2);
    DEod = datevec(date, 'dd-mmm-yyyy');
    DEod = DEod(:, 1:3);
    r = diff(log(raw.data)) .* 100;

    % Align the dates of EOD data with 1-minute data
    [Xi, r, D] = syncdate(D1min, Xi, DEod, r);
    logX = syncdate(D1min, logX, D, r);
end
