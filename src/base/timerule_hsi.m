function tf = timerule_hsi(Dv)
% tf = timerule_hsi(Dv) determines whether a price has a valid timestamp.
% This rule considers a price as valid if it is between (or at):
% - 10:00 and 12:30, 14:30 and 16:00, before 07-Mar-2011,
% - 9:30 and 12:00, 13:30 and 16:00, from 07-Mar-2011 to 04-Mar-2012,
% - 9:30 and 12:00, 13:00 and 16:00, after 04-Mar-2012.
%
% Author: Ye Wilson Chen <yche5077@uni.sydney.edu.au>
% Date:   May 26, 2016

    nDv = size(Dv, 1);
    dnDate = datenum(Dv(:, 1:3));
    dnTime = datenum([zeros(nDv, 3), Dv(:, 4:6)]);
    
    p1 = dnDate <= datenum([2011, 3, 6]);
    p2 = dnDate >= datenum([2011, 3, 7]) & dnDate <= datenum([2012, 3, 4]);
    p3 = dnDate >= datenum([2012, 3, 5]);
    
    dn0930 = datenum([0, 0, 0, 9, 30, 0]);
    dn1000 = datenum([0, 0, 0, 10, 0, 0]);
    dn1200 = datenum([0, 0, 0, 12, 0, 0]);
    dn1230 = datenum([0, 0, 0, 12, 30, 0]);
    dn1300 = datenum([0, 0, 0, 13, 0, 0]);
    dn1330 = datenum([0, 0, 0, 13, 30, 0]);
    dn1430 = datenum([0, 0, 0, 14, 30, 0]);
    dn1600 = datenum([0, 0, 0, 16, 0, 0]);
    
    tf = ...
        (p1 & dnTime >= dn1000 & dnTime <= dn1230) | ...
        (p1 & dnTime >= dn1430 & dnTime <= dn1600) | ...
        (p2 & dnTime >= dn0930 & dnTime <= dn1200) | ...
        (p2 & dnTime >= dn1330 & dnTime <= dn1600) | ...
        (p3 & dnTime >= dn0930 & dnTime <= dn1200) | ...
        (p3 & dnTime >= dn1300 & dnTime <= dn1600);
end
