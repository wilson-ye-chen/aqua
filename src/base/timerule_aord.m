function tf = timerule_aord(Dv)
% tf = timerule_aord(Dv) determines whether a price has a valid timestamp.
% This rule considers a price as valid if it is between (or at) 10:00 and
% 16:00.
%
% Author: Ye Wilson Chen <yche5077@uni.sydney.edu.au>
% Date:   May 26, 2016

    nDv = size(Dv, 1);
    dnTime = datenum([zeros(nDv, 3), Dv(:, 4:6)]);
    
    dn1000 = datenum([0, 0, 0, 10, 0, 0]);
    dn1600 = datenum([0, 0, 0, 16, 0, 0]);
    
    tf = dnTime >= dn1000 & dnTime <= dn1600;
end
