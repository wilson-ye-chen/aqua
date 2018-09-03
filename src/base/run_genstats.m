function run_genstats(dirName)
% run_genstats(dirName) generates matrix files (.mat) from raw data
% files (.csv), where each matrix file contains the summary statistics
% relevant to data cleaning.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   June 7, 2016

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
    
    % Maximum gap allowed
    cTol = 30;
    
    % Maximum outlier score allowed
    sTol = 20;
    
    % Generate matrix file for each key
    for i = 1:numel(key)
        file = [dirName, '/', key{i}, '_1min.csv'];
        timerule = str2func(['timerule_', key{i}]);
        [nObs, nGap, maxC, nOut, maxS, p, T, D, iD] = genstats( ...
            file, timerule, cTol, sTol);
        fileOut = [dirName, '/stats_', key{i}, '.mat'];
        save(fileOut, ...
            'nObs', 'nGap', 'maxC', 'nOut', 'maxS', ...
            'p', 'T', 'D', 'iD');
        disp([key{i}, ' generated.']);
    end
end
