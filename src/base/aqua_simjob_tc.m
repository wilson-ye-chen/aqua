function aqua_simjob_tc(dataFile, outFile, idx)
% aqua_simjob_tc(dataFile, outFile, idx) is the top-level function for running
% the simulation study of the AQUA-gh-tc model. This file should be used as
% the main file for the Matlab compiler.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   February 12, 2016

    load(dataFile);
    idx = str2num(idx);
    Xii = Xi(:, :, idx);
    rng('shuffle', 'twister');
    rngState = rng();
    [Theta, Accept, mapc, ThetaAd, Scale] = aqua_est_tc(Xii, 105000, 5000);
    save(outFile, ...
        'idx', 'rngState', ...
        'Theta', 'Accept', 'mapc', 'ThetaAd', 'Scale');
end
