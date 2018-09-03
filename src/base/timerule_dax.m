function tf = timerule_dax(Dv)
% tf = timerule_dax(Dv) determines whether a price has a valid timestamp.
% This rule considers a price as valid if it is between (or at):
% - 8:30 and 17:00, before 18-Sept-1999,
% - 9:00 and 17:30, from 18-Sept-1999.
%
% Author: Ye Wilson Chen <yche5077@uni.sydney.edu.au>
% Date:   June 19, 2016

    nDv = size(Dv, 1);
    dnDate = datenum(Dv(:, 1:3));
    dnTime = datenum([zeros(nDv, 3), Dv(:, 4:6)]);
    
    p1 = dnDate <= datenum([1998, 9, 17]);
    p2 = dnDate >= datenum([1999, 9, 18]);
    
    dn0830 = datenum([0, 0, 0, 8, 30, 0]);
    dn0900 = datenum([0, 0, 0, 9, 0, 0]);
    dn1700 = datenum([0, 0, 0, 17, 0, 0]);
    dn1730 = datenum([0, 0, 0, 17, 30, 0]);
    
    tf = ...
        (p1 & dnTime >= dn0830 & dnTime <= dn1700) | ...
        (p2 & dnTime >= dn0900 & dnTime <= dn1730);
end
