function margin_estjob_h(dataFile, outFile)
% margin_estjob_h(dataFile, outFile) is the top-level function for estimating
% the marginal models (Apat vs TrSkt) for h.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   June 22, 2017

    load(dataFile);
    rng('shuffle', 'twister');
    rngState = rng();

    % Simulate from Apatosaurus posterior
    disp('Estimating Apatosaurus model...');
    h = Xi(:, 4);
    ThetaApat = margin_est_apat(h, 105000, 5000);

    % Conditional mean and conditional weight estimates
    mu0 = mean(h);
    [mu, w] = margin_avemu_apat(ThetaApat, mu0, h);
    mu = mu(1:(end - 1));
    w = w(1:(end - 1));

    % Other Apatosaurus parameters
    sig = mean(ThetaApat(:, 6));
    eta = mean(ThetaApat(:, 7));
    lda = mean(ThetaApat(:, 8));
    iot = mean(ThetaApat(:, 9));

    % Probability integral transform
    uApat = apatcdf(h, mu, sig, eta, lda, iot, w);
    zApat = norminv(uApat, 0, 1);

    % Simulate from truncated-skewed-t posterior
    disp('Estimating truncated-skewed-t model...');
    ThetaTrSkt = margin_est_trskt(h, 105000, 5000);

    % Conditional mean estimates
    mu = margin_avemu_trskt(ThetaTrSkt, mu0, h);
    mu = mu(1:(end - 1));

    % Other truncated-skewed-t parameters
    sig = mean(ThetaTrSkt(:, 4));
    eta = mean(ThetaTrSkt(:, 5));
    lda = mean(ThetaTrSkt(:, 6));

    % Probability integral transform
    uTrSkt = trsktcdf(h, mu, sig, eta, lda);
    zTrSkt = norminv(uTrSkt, 0, 1);

    % Save results
    save(outFile, ...
        'rngState', 'D', 'h', ...
        'ThetaApat', 'ThetaTrSkt', ...
        'uApat', 'zApat', 'uTrSkt', 'zTrSkt');
    disp(['Written to file: ', outFile]);
end
