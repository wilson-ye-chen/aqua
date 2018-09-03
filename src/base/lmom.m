function l = lmom(x)
% l = lmom(x) estimates the first four sample L-moments using
% probability weighted moments. This method is computationally
% simpler than the direct method of Q.J. Wang (1996).
%
% Input:
% x - vector of observations.
%
% Output:
% l - 1-by-4 vector of sample L-moments.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   April 6, 2015

    n = numel(x);
    o = sort(x(:), 'ascend');
    i = 1:n;
    
    w1 = (i - 1) ./ (n - 1);
    w2 = w1 .* (i - 2) ./ (n - 2);
    w3 = w2 .* (i - 3) ./ (n - 3);
    
    m0 = sum(o) ./ n;
    m1 = w1 * o ./ n;
    m2 = w2 * o ./ n;
    m3 = w3 * o ./ n;
    
    l1 = m0;
    l2 = 2 .* m1 - m0;
    l3 = 6 .* m2 - 6 .* m1 + m0;
    l4 = 20 .* m3 - 30 .* m2 + 12 .* m1 - m0;
    
    l = [l1, l2, l3, l4];
end
