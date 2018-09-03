function Stat = run_gendata(dirName)
% Stat = run_gendata(dirName) generates matrix files (.mat) from raw data
% files (.csv). The generated files are stored in the current working
% directory.
%
% Input:
% dirName - raw data directory containing the ".csv" files.
%
% Output:
% Stat    - matrix of data cleaning summary, where each row is a summary
%           vector for one data file: (nD, nDDel, nP, nPDel, fPDel).
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   June 7, 2017

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
        fileEod = [dirName, '/', key{i}, '_eod.csv'];
        timerule = str2func(['timerule_', key{i}]);
        [D, Xi, logX, r, Stat(i, :)] = gendata(file1min, fileEod, timerule);
        fileOut = ['data_', key{i}, '.mat'];
        save(fileOut, 'D', 'Xi', 'logX', 'r');
        disp([key{i}, ' generated.']);
    end
end
