function run_estjob_ar1(dirName)
% run_estjob_ar1(dirName) fits simple models to all the indices.
% The result files are stored in the current working directory.
%
% Input:
% dirName - directory containing the data files.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   May 9, 2018

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

    % Fit the models for each key
    for i = 1:numel(key)
        dataFile = [dirName, '/data_', key{i}, '.mat'];
        outFile = ['./estresult_ar1_', key{i}, '.mat'];
        aqua_estjob_ar1(dataFile, outFile);
        disp([key{i}, ' done.']);
    end
end
