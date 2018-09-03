function result = ghsimstudy(X)
% result = ghsimstudy(X) iteratively applies estimators of the parameters
% of the g-and-h distribution to each row of X. Rows of X are estimated in
% parallel whenever feasible.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   April 2, 2015

    nIter = size(X, 1);
    timerMom     = zeros(nIter, 1);
    GhMom        = zeros(nIter, 4);
    fValMom      = zeros(nIter, 1);
    exitFlagMom  = zeros(nIter, 1);
    timerQm      = zeros(nIter, 1);
    GhQm         = zeros(nIter, 4);
    mQm          = zeros(nIter, 1);
    fValQm       = zeros(nIter, 1);
    exitFlagQm   = zeros(nIter, 1);
    timerMl      = zeros(nIter, 1);
    GhMl         = zeros(nIter, 4);
    fValMl       = zeros(nIter, 1);
    exitFlagMl   = zeros(nIter, 1);
    timerLmom    = zeros(nIter, 1);
    GhLmom       = zeros(nIter, 4);
    fValLmom     = zeros(nIter, 1);
    exitFlagLmom = zeros(nIter, 1);
    
    % For each row of X
    parfor i = 1:nIter
        % Print row index
        disp(['Estimating: row ', num2str(i)]);
        % Moment matching
        tic;
        [gh, fVal, exitFlag] = ghfit_mom(X(i, :));
        timerMom(i) = toc;
        GhMom(i, :) = gh;
        fValMom(i) = fVal;
        exitFlagMom(i) = exitFlag;
        % Quantile matching
        tic;
        [gh, m, fVal, exitFlag] = ghfit_qmxic(X(i, :));
        timerQm(i) = toc;
        GhQm(i, :) = gh;
        mQm(i, :) = m;
        fValQm(i) = fVal;
        exitFlagQm(i) = exitFlag;
        % Maximum likelihood
        tic;
        [gh, fVal, exitFlag] = ghfit_ml(X(i, :));
        timerMl(i) = toc;
        GhMl(i, :) = gh;
        fValMl(i) = fVal;
        exitFlagMl(i) = exitFlag;
        % L-moment matching
        tic;
        [gh, fVal, exitFlag] = ghfit_lmom(X(i, :));
        timerLmom(i) = toc;
        GhLmom(i, :) = gh;
        fValLmom(i) = fVal;
        exitFlagLmom(i) = exitFlag;
    end
    
    result.mom.timer     = timerMom;
    result.mom.Gh        = GhMom;
    result.mom.fVal      = fValMom;
    result.mom.exitFlag  = exitFlagMom;
    result.qm.timer      = timerQm;
    result.qm.Gh         = GhQm;
    result.qm.m          = mQm;
    result.qm.fVal       = fValQm;
    result.qm.exitFlag   = exitFlagQm;
    result.ml.timer      = timerMl;
    result.ml.Gh         = GhMl;
    result.ml.fVal       = fValMl;
    result.ml.exitFlag   = exitFlagMl;
    result.lmom.timer    = timerLmom;
    result.lmom.Gh       = GhLmom;
    result.lmom.fVal     = fValLmom;
    result.lmom.exitFlag = exitFlagLmom;
end
