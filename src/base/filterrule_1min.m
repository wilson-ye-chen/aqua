function [d, iPd] = filterrule_1min(pD)
% [d, iPd] = filterrule_1min(pD) implements a filter rule for 1-minute
% prices of a single day.
%
% A price is marked invalid if it:
% P1 - is zero or negative,
% P2 - is part of the leading or trailing gap,
% P3 - is part of a gap longer than 30 minutes,
% P4 - has an outlier score of over 20.
%
% The entire day is marked invalid if it:
% D1 - has less than 60 valid observations.
%
% Input:
% pD  - vector of 1-minute prices.
%
% Output:
% d   - binary flag whose value is zero if the day is invalid.
% iPd - binary vector where a zero indicates an invalid price.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   May 30, 2017

    % Filter thresholds
    minObs = 60;
    maxGap = 30;
    maxScr = 20;

    d = true;
    iPd = true(size(pD));

    % Short circuit if data is insufficient
    nObs = numel(pD);
    if nObs < minObs
        d = false;
        iPd(:) = false;
        return
    end

    % Remove zero and negative prices
    iPd = (pD > 0);

    % Remove gaps (consecutive repeating prices)
    [n, a, b] = consec(diff(pD) == 0);
    if ~isempty(n)
        % Remove any leading gap
        if a(1) == 1
            iPd(a(1):b(1)) = false;
        end
        % Remove any trailing gap
        if b(end) == (nObs - 1)
            iPd(a(end):b(end)) = false;
        end
        % Remove any long gaps
        iL = n > maxGap;
        aL = a(iL);
        bL = b(iL);
        for i = 1:numel(aL)
            iPd(aL(i):bL(i)) = false;
        end
    end

    % Remove outliers after gaps are removed
    if sum(iPd) >= minObs
        st = 50;
        ss = 50000;
        score = l1outscore(pD(iPd), st, ss);
        int = find(iPd);
        iPd(int(score > maxScr)) = false;
    end

    % Check again the remaining number of observations
    if sum(iPd) < minObs
        d = false;
        iPd(:) = false;
    end
end
