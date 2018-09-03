function tf = timerule_spx(Dv)
% tf = timerule_spx(Dv) determines whether a price has a valid timestamp.
% This rule considers a price as valid if it is between (or at) 9:30 and
% 16:00.
%
% Author: Ye Wilson Chen <yche5077@uni.sydney.edu.au>
% Date:   May 26, 2016

    nDv = size(Dv, 1);
    dnTime = datenum([zeros(nDv, 3), Dv(:, 4:6)]);
    
    dn0930 = datenum([0, 0, 0, 9, 30, 0]);
    dn1600 = datenum([0, 0, 0, 16, 0, 0]);
    
    tf = dnTime >= dn0930 & dnTime <= dn1600;
end
