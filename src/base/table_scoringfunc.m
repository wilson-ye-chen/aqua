function [T1, T5] = table_scoringfunc(dir)
% [T1, T5] = table_scoringfunc(dir) creates a table of scoring function
% values for quantile levels 0.01 and 0.05.
%
% Input:
% dir - directory containing the forecasting results.
%
% Output:
% T1  - table of scoring function values for quantile level 0.01.
% T5  - table of scoring function values for quanitle level 0.05.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   August 25, 2017

    % Models
    model{1} = 'caviar';
    model{2} = 'gjrt';
    model{3} = 'gjrskt';
    model{4} = 'realt';
    model{5} = 'realskt';
    model{6} = 'aqua';

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

    % Create table
    nModel = numel(model);
    nData = numel(data);
    T1 = zeros(nModel, nData);
    T5 = zeros(nModel, nData);
    for i = 1:nModel
        for j = 1:nData
            fore = ['.3051-', last{j}, '.mat'];
            load([dir, '/', model{i}, '.', data{j}, fore]);
            T1(i, j) = mean(score1);
            T5(i, j) = mean(score5);
        end
    end
end
