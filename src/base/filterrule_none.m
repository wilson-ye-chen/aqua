function [d, iPd] = filterrule_none(pD)
% [d, iPd] = filterrule_none(pD) implements the identity filter.
%
% Input:
% pD  - vector of 1-minute prices.
%
% Output:
% d   - binary flag whose value is zero if the day is invalid.
% iPd - binary vector where a zero indicates an invalid price.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   May 24, 2017

    d = true;
    iPd = true(size(pD));
end
