function Stat = run_genprice(dirName)
% Stat = run_genprice(dirName) generates matrix files (.mat) of cleaned
% price data from raw data files (.csv). The generated files are stored
% in the current working directory.
%
% Input:
% dirName - raw data directory containing the ".csv" files.
%
% Output:
% Stat    - matrix of data cleaning summary, where each row is a summary
%           vector for one data file: (nD, nDDel, nP, nPDel, fPDel).
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   June 10, 2017

    % Data identifiers
    key{1}  = 'spx';
    key{2}  = 'djia';
    key{3}  = 'nasdaq';
    key{4}  = 'ftse';
    key{5}  = 'dax';
    key{6}  = 'cac';
    key{7}  = 'nikkei';
    key{8}  = 'hsi';
    key{9}  = 'ssec';
    key{10} = 'aord';

    % Generate matrix file for each key
    nKey = numel(key);
    Stat = zeros(nKey, 5);
    for i = 1:nKey
        file1min = [dirName, '/', key{i}, '_1min.csv'];
        timerule = str2func(['timerule_', key{i}]);
        [p, T, D, iD, iDKeep, Stat(i, :)] = genprice(file1min, timerule);
        fileOut = ['pricedata_', key{i}, '.mat'];
        save(fileOut, 'p', 'T', 'D', 'iD', 'iDKeep');
        disp([key{i}, ' generated.']);
    end
end
