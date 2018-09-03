function [p, e] = dq_mcpval(dq, dqMc)
% [p, e] = dq_mcpval(dq, dqMc) computes the Monte Carlo p-value of the
% DQ test using a table-lookup of the tabulated empirical distribution
% function of the generated MC samples under the null hypothesis.
%
% Input:
% dq   - the observed DQ statistic.
% dqMc - vector of MC samples under the null hypothesis.
%
% Output:
% p    - the MC p-value.
% e    - the absolute difference between the observed test statistic
%        and the nearest observation in the MC sample.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   October 8, 2015

    [u, x] = ecdf(dqMc);
    [e, i] = min(abs(x - dq));
    p = 1 - u(i);
end
