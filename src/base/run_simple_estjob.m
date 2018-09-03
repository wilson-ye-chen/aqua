function run_simple_estjob(dirName)
% run_simple_estjob(dirName) fits simple models to all the indices.
% The result files are stored in the current working directory.
%
% Input:
% dirName - directory containing the data files.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   May 28, 2017

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
        outFile1 = ['./estresult_caviar_', key{i}, '.mat'];
        outFile2 = ['./estresult_gjrt_', key{i}, '.mat'];
        outFile3 = ['./estresult_gjrskt_', key{i}, '.mat'];
        outFile4 = ['./estresult_realt_', key{i}, '.mat'];
        outFile5 = ['./estresult_realskt_', key{i}, '.mat'];
        caviar_sav_estjob(dataFile, outFile1);
        gjr_estjob_t(dataFile, outFile2);
        gjr_estjob_skt(dataFile, outFile3);
        realgarch_estjob_t(dataFile, outFile4);
        realgarch_estjob_skt(dataFile, outFile5);
        disp([key{i}, ' done.']);
    end
end
