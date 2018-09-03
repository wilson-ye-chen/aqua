function run_joinforejob(dir)
% run_joinforejob(dir) generates joined result files from the individual
% forecasting output files. The joined files are generated in the current
% working directory.
%
% Input:
% dir - top-level directory containing the forecasting output files.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   August 25, 2017

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

    % Indices of the last forecasting day
    last{1}  = '5084';
    last{2}  = '5080';
    last{3}  = '5083';
    last{4}  = '5117';
    last{5}  = '4872';
    last{6}  = '5159';
    last{7}  = '4946';
    last{8}  = '4979';
    last{9}  = '4886';
    last{10} = '5117';

    % Join all the files for each key
    nKey = numel(key);
    for i = 1:nKey
        subDir = [dir, '/', key{i}];
        [DFore, Q, var1, var5, score1, score5, s1, s5, Mn, Sd, w, ...
            Theta, AccRate, Mapc] = aqua_joinforejob(subDir);
        name = ['aqua.', key{i}, '.3051-', last{i}, '.mat'];
        save(name, ...
            'DFore', 'Q', 'var1', 'var5', 'score1', 'score5', ...
            's1', 's5', 'Mn', 'Sd', 'w', 'Theta', 'AccRate', 'Mapc');
        disp([key{i}, ' generated.']);
    end
end
