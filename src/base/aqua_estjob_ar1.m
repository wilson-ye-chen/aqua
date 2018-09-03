function aqua_estjob_ar1(dataFile, outFile)
% aqua_estjob_ar1(dataFile, outFile) is the top-level function for running
% the in-sample part of the empirical study of the AQUA-AR(1) model.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   May 9, 2018

    load(dataFile);
    rng('shuffle', 'twister');
    rngState = rng();

    % Simulate from AQUA-AR(1) posterior
    Theta = aqua_est_ar1(Xi, 52000, 2000);

    % Save results
    save(outFile, 'rngState', 'D', 'Xi', 'r', 'Theta');
end
