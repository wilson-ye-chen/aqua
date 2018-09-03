function [p, T, D, iD] = import1min(date, time, offset, last, timerule)
% [p, T, D, iD] = import1min(date, time, offset, last, timerule) imports
% 1-minute price data. The main purpose of this function is to filter out
% prices with invalid timestamps.
%
% Input:
% date     - cell array of date strings of the format dd-mmm-yyyy.
% time     - cell array of time strings of the format HH:MM:SS.
% offset   - vector of time offsets in hours.
% last     - vector of last recored prices in one minute intervals.
% timerule - handle to a function tf = timerule(Dv) where Dv is a n-by-6
%            matrix of date vectors and tf is a n-by-1 vector of logicals.
%
% Output:
% p        - vector of valid prices.
% T        - Matrix of full timestamps.
% D        - Matrix of daily timestamps.
% iD       - vector of daily indices.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   May 30, 2017

    nObs = numel(date);

    % Convert the timestamps to local times
    str = strcat(date, strcat('-', time));
    dnGmt = datenum(str, 'dd-mmm-yyyy-HH:MM:SS');
    dnLoc = zeros(nObs, 1);
    for i = 1:nObs
        dnLoc(i) = addtodate(dnGmt(i), offset(i), 'hour');
    end
    DvLoc = datevec(dnLoc);

    % Return valid observations
    iValid = timerule(DvLoc);
    p = last(iValid);
    T = DvLoc(iValid, :);

    % Timestamps in days
    [D, ~, iD] = unique(T(:, 1:3), 'rows');
end
