function run_genapatrsig(dirName)
% run_genapatrsig(dirName) generates matrix files (.mat) of posterior draws
% of the signal ratio for the Apatosaurus conditional marginal model. The
% generated files are stored in the current working directory.
%
% Input:
% dirName - directory containing the estimation results.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   June 30, 2017

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
    for i = 1:nKey
        rng('shuffle', 'twister');
        rngState = rng();
        load([dirName, '/estresult_aqua_', key{i}, '.mat']);
        [rSigApat, iThin] = aqua_rsigpost_apatmar(Theta, 500);
        name = ['estresult_apatrsig_', key{i}, '.mat'];
        save(name, 'rngState', 'rSigApat', 'iThin');
        disp([key{i}, ' generated.']);
    end
end
