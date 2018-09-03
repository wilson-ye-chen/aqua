function run_dic(dirName)
% run_dic(dirName) computes the DIC for AQUA-TC and AQUA-AR(1).
% The result file is stored in the current working directory.
%
% Input:
% dirName - directory containing the data files.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   May 10, 2018

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

    % Compute DICs for each key
    Dic = zeros(2, 10);
    DAve = zeros(2, 10);
    Pd = zeros(2, 10);
    for i = 1:numel(key)
        % AR(1)
        load([dirName, '/estresult_ar1_', key{i}, '.mat']);
        mu0 = mean(Xi, 1);
        nPre = 50;
        [Dic(1, i), DAve(1, i), ~, Pd(1, i)] = aqua_dic_ar1( ...
            Theta, mu0, nPre, Xi);
        % TC
        load([dirName, '/estresult_aqua_', key{i}, '.mat']);
        ThetaThin = Theta(randperm(size(Theta, 1), 20000), :);
        nSigmaSq0 = size(Xi, 1);
        [Dic(2, i), DAve(2, i), ~, Pd(2, i)] = aqua_dic_tc( ...
            ThetaThin, mu0, nSigmaSq0, nPre, Xi);
        disp([key{i}, ' done.']);
    end

    % Save Output
    save('./dicresult.mat', 'key', 'Dic', 'DAve', 'Pd');
end
