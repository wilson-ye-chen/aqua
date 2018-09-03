function m = ghmom(Gh, k)
% m = ghmom(Gh, k) computes the k-th raw moment of the g-and-h distribution.
% The expressions of raw moments of the g-and-h distribution can be found in
% Dutta and Babbel (2002) and Martinez and Iglewicz (1984). This function
% returns NaN if the moment does not exist. Gh can be a matrix where each
% row is a set of four parameters. k must be a positive integer scalar. This
% function is numerically unstable if g is very close to zero, however it is
% accurate if g is exactly zero.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   March 15, 2015

    iExist = Gh(:, 4) < 1 ./ k;
    iGh = logical(Gh(:, 3)) & iExist;
    iH = (~iGh) & iExist;
    
    m = zeros(size(Gh, 1), 1);
    m(~iExist) = nan;
    m(iGh) = ghm(Gh(iGh, :), k);
    m(iH) = hm(Gh(iH, :), k);
end

function m = ghm(Gh, k)
    a = Gh(:, 1);
    b = Gh(:, 2);
    g = Gh(:, 3);
    h = Gh(:, 4);
    m = 0;
    for i = 0:k
        s = 0;
        for j = 0:i
            s = s + (-1) .^ j .* nchoosek(i, j) .* ...
                exp((i - j) .^ 2 .* g .^ 2 ./ (2 .* (1 - i .* h)));
        end
        m = m + nchoosek(k, i) .* a .^ (k - i) .* b .^ i .* ...
            s ./ ((1 - i .* h) .^ 0.5 .* g .^ i);
    end
end

function m = hm(Gh, k)
    a = Gh(:, 1);
    b = Gh(:, 2);
    h = Gh(:, 4);
    m = 0;
    for i = 0:k
        if iseven(i)
            m = m + nchoosek(k, i) .* a .^ (k - i) .* b .^ i .* ...
                factorial(i) .* (1 - i .* h) .^ (-(i + 1) ./ 2) ./ ...
                (2 .^ (i ./ 2) .* factorial(i ./ 2));
        end
    end
end

function tf = iseven(i)
    tf = ~mod(i, 2);
end
