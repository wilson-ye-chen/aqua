function tf = timerule_ftse(Dv)
% tf = timerule_ftse(Dv) determines whether a price has a valid timestamp.
% This rule considers a price as valid if it is between (or at):
% - 8:30 and 16:30, before 20-Jul-1998,
% - 9:00 and 16:30, from 20-Jul-1998 to 17-Sept-1999,
% - 8:00 and 16:30, after 17-Sept-1999.
%
% Author: Ye Wilson Chen <yche5077@uni.sydney.edu.au>
% Date:   June 19, 2016

    nDv = size(Dv, 1);
    dnDate = datenum(Dv(:, 1:3));
    dnTime = datenum([zeros(nDv, 3), Dv(:, 4:6)]);
    
    p1 = dnDate <= datenum([1998, 7, 19]);
    p2 = dnDate >= datenum([1998, 7, 20]) & dnDate <= datenum([1999, 9, 17]);
    p3 = dnDate >= datenum([1999, 9, 18]);
    
    dn0800 = datenum([0, 0, 0, 8, 0, 0]);
    dn0830 = datenum([0, 0, 0, 8, 30, 0]);
    dn0900 = datenum([0, 0, 0, 9, 0, 0]);
    dn1630 = datenum([0, 0, 0, 16, 30, 0]);
    
    tf = ...
        (p1 & dnTime >= dn0830 & dnTime <= dn1630) | ...
        (p2 & dnTime >= dn0900 & dnTime <= dn1630) | ...
        (p3 & dnTime >= dn0800 & dnTime <= dn1630);
end
