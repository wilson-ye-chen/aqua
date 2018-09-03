function gjr_forejob_skt(dataFile, outFile, nEst, intEst, iStart, iEnd)
% gjr_forejob_skt(dataFile, outFile, nEst, intEst, iStart, iEnd) is the top-
% level function for running the forecasting study of the GJR-skt model. This
% file should be used as the main file for the Matlab compiler.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   February 12, 2016

    load(dataFile);
    rng('shuffle', 'twister');
    rngState = rng();
    [DFore, var1, var5, score1, score5, Theta, AccRate, Mapc] = ...
        gjr_fore_skt(D, r, ...
        str2num(nEst), ...
        str2num(intEst), ...
        str2num(iStart), ...
        str2num(iEnd));
    save(outFile, ...
        'rngState', ...
        'DFore', 'var1', 'var5', 'score1', 'score5', ...
        'Theta', 'AccRate', 'Mapc');
end