function tf = timerule_ssec(Dv)
% tf = timerule_ssec(Dv) determines whether a price has a valid timestamp.
% This rule considers a price as valid if it is between (or at) 9:30 and
% 11:30, or is between (or at) 13:00 and 15:00.
%
% Author: Ye Wilson Chen <yche5077@uni.sydney.edu.au>
% Date:   May 26, 2016

    nDv = size(Dv, 1);
    dnTime = datenum([zeros(nDv, 3), Dv(:, 4:6)]);
    
    dn0930 = datenum([0, 0, 0, 9, 30, 0]);
    dn1130 = datenum([0, 0, 0, 11, 30, 0]);
    dn1300 = datenum([0, 0, 0, 13, 0, 0]);
    dn1500 = datenum([0, 0, 0, 15, 0, 0]);
    
    tf = ...
        (dnTime >= dn0930 & dnTime <= dn1130) | ...
        (dnTime >= dn1300 & dnTime <= dn1500);
end
