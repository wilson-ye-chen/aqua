function S = scoringfunc(Y, Q, U)
% S = scoringfunc(Y, Q, U) evaluates the scoring function for the predicted
% quantiles. The scoring function is an important ingredient of the concept
% of elicitability (Gneiting, 2011; Ziegel, 2014; Ehm et al, 2016).
%
% Input:
% Y - observation.
% Q - predicted quantile.
% U - quantile level.
%
% Output:
% S - realised score.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   May 26, 2017

    S = (double(Y < Q) - U) .* (Q - Y);
end
