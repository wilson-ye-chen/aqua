function l = lmom_dir(x)
% l = lmom_dir(x) estimates the first 4 sample L-moments. This Matlab
% implementation is ported directly from the FORTRAN implementation
% of Q.J. Wang (1996).
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
    
    cl1 = i - 1;
    cl2 = cl1 .* (i - 1 - 1) ./ 2;
    cl3 = cl2 .* (i - 1 - 2) ./ 3;
    cr1 = n - i;
    cr2 = cr1 .* (n - i - 1) ./ 2;
    cr3 = cr2 .* (n - i - 2) ./ 3;
    
    l1 = sum(o);
    l2 = (cl1 - cr1) * o;
    l3 = (cl2 - (2 .* cl1 .* cr1) + cr2) * o;
    l4 = (cl3 - (3 .* cl2 .* cr1) + (3 .* cl1 .* cr2) - cr3) * o;
    
    c1 = n;
    c2 = c1 .* (n - 1) ./ 2;
    c3 = c2 .* (n - 2) ./ 3;
    c4 = c3 .* (n - 3) ./ 4;
    
    l1 = l1 ./ c1;
    l2 = l2 ./ c2 ./ 2;
    l3 = l3 ./ c3 ./ 3;
    l4 = l4 ./ c4 ./ 4;
    
    l = [l1, l2, l3, l4];
end
