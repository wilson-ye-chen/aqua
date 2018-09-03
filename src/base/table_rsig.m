function T = table_rsig(dirName)
% T = table_rsig(dirName) creates a table of signal ratios.
%
% Input:
% dirName - directory containing the estimation results.
%
% Output:
% T       - table of signal ratios.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   June 30, 2017

    % Data identifiers
    data{1}  = 'spx';
    data{2}  = 'djia';
    data{3}  = 'nasdaq';
    data{4}  = 'ftse';
    data{5}  = 'dax';
    data{6}  = 'cac';
    data{7}  = 'nikkei';
    data{8}  = 'hsi';
    data{9}  = 'ssec';
    data{10} = 'aord';

    % Create table
    nData = numel(data);
    T = zeros(12, nData);
    for i = 1:nData
        load([dirName, '/estresult_aqua_', data{i}, '.mat']);
        load([dirName, '/estresult_apatrsig_', data{i}, '.mat']);
        for j = 1:4
            % Use Monte Carlo signal ratio for Apatosaurus model
            if j <= 3
                sr = RSig(:, j);
            else
                sr = rSigApat;
            end
            T((j - 1) .* 3 + 1, i) = mean(sr);
            T((j - 1) .* 3 + 2, i) = quantile(sr, 0.025);
            T((j - 1) .* 3 + 3, i) = quantile(sr, 0.975);
        end
    end
end
