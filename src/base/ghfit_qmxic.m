function [gh, m, fVal, exitFlag] = ghfit_qmxic(x)
% [gh, m, fVal, exitFlag] = ghfit_qmxic(x) estimates the parameters of the
% g-and-h distribution by quantile matching, where the set of quantiles are
% selected automatically using a heuristic based on the AIC, proposed by Xu,
% Iglewicz, and Chervoneva (2014).
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   April 2, 2015

    vM = 4:20;
    nM = numel(vM);
    nX = numel(x);
    k = 1:nX;
    p = (k - 1 ./ 3) ./ (nX + 1 ./ 3);
    qX = quantile(x, p);
    aicMin = inf;
    for i = 1:nM
        j = 1:vM(i);
        u = (j - 1 ./ 3) ./ (vM(i) + 1 ./ 3);
        [ghM, fValM, exitFlagM] = ghfit_qm(x, u);
        err = qX - ghinv(p, ghM);
        sse = err * err';
        aic = nX .* log(sse ./ nX) + 2 .* (vM(i) + 1);
        if aic < aicMin
            gh = ghM;
            m = vM(i);
            fVal = fValM;
            exitFlag = exitFlagM;
            aicMin = aic;
        end
    end
end
