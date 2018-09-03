function tf = timerule_cac(Dv)
% tf = timerule_cac(Dv) determines whether a price has a valid timestamp.
% This rule considers a price as valid if it is between (or at):
% - 10:00 and 17:00, before 20-Sept-1999,
% - 9:00 and 17:00, from 20-Sept-1999 to 2-Apr-2000,
% - 9:00 and 17:30, after 2-Apr-2000.
%
% Author: Ye Wilson Chen <yche5077@uni.sydney.edu.au>
% Date:   June 19, 2016

    nDv = size(Dv, 1);
    dnDate = datenum(Dv(:, 1:3));
    dnTime = datenum([zeros(nDv, 3), Dv(:, 4:6)]);
    
    p1 = dnDate <= datenum([1999, 9, 19]);
    p2 = dnDate >= datenum([1999, 9, 20]) & dnDate <= datenum([2000, 4, 2]);
    p3 = dnDate >= datenum([2000, 4, 3]);
    
    dn0900 = datenum([0, 0, 0, 9, 0, 0]);
    dn1000 = datenum([0, 0, 0, 10, 0, 0]);
    dn1700 = datenum([0, 0, 0, 17, 0, 0]);
    dn1730 = datenum([0, 0, 0, 17, 30, 0]);
    
    tf = ...
        (p1 & dnTime >= dn1000 & dnTime <= dn1700) | ...
        (p2 & dnTime >= dn0900 & dnTime <= dn1700) | ...
        (p3 & dnTime >= dn0900 & dnTime <= dn1730);
end
