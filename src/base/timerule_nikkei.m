function tf = timerule_nikkei(Dv)
% tf = timerule_nikkei(Dv) determines whether a price has a valid timestamp.
% This rule considers a price as valid if it is between (or at):
% - 9:00 and 11:00, 12:30 and 15:00, before 19-Jan-2006,
% - 9:00 and 11:00, 13:00 and 15:00, from 19-Jan-2006 to 23-Apr-2006,
% - 9:00 and 11:00, 12:30 and 15:00, from 24-Apr-2006 to 20-Nov-2011,
% - 9:00 and 11:30, 12:30 and 15:00, after 20-Nov-2011.
%
% Author: Ye Wilson Chen <yche5077@uni.sydney.edu.au>
% Date:   June 19, 2016

    nDv = size(Dv, 1);
    dnDate = datenum(Dv(:, 1:3));
    dnTime = datenum([zeros(nDv, 3), Dv(:, 4:6)]);
    
    p1 = dnDate <= datenum([2006, 1, 18]);
    p2 = dnDate >= datenum([2006, 1, 19]) & dnDate <= datenum([2006, 4, 23]);
    p3 = dnDate >= datenum([2006, 4, 24]) & dnDate <= datenum([2011, 11, 20]);
    p4 = dnDate >= datenum([2011, 11, 21]);
    
    dn0900 = datenum([0, 0, 0, 9, 0, 0]);
    dn1100 = datenum([0, 0, 0, 11, 0, 0]);
    dn1130 = datenum([0, 0, 0, 11, 30, 0]);
    dn1230 = datenum([0, 0, 0, 12, 30, 0]);
    dn1300 = datenum([0, 0, 0, 13, 0, 0]);
    dn1500 = datenum([0, 0, 0, 15, 0, 0]);
    
    tf = ...
        (p1 & dnTime >= dn0900 & dnTime <= dn1100) | ...
        (p1 & dnTime >= dn1230 & dnTime <= dn1500) | ...
        (p2 & dnTime >= dn0900 & dnTime <= dn1100) | ...
        (p2 & dnTime >= dn1300 & dnTime <= dn1500) | ...
        (p3 & dnTime >= dn0900 & dnTime <= dn1100) | ...
        (p3 & dnTime >= dn1230 & dnTime <= dn1500) | ...
        (p4 & dnTime >= dn0900 & dnTime <= dn1130) | ...
        (p4 & dnTime >= dn1230 & dnTime <= dn1500);
end
