function [z, error] = l1spline(y, s, l, nBreg, nInner, epsilon)
%L1SPLINE L1 spline approximation of the signal y
%     M. Tepper, G. Sapiro.
%     "Fast L1 smoothing splines 
%     with an application to Kinect depth data."
%     ICIP, 2013.
% 
%     Regularization parameters
%       s: main smoothing parameter
%       l: split bregman smoothing parameter (lambda in the paper)
%     Stopping criteria:
%       nBreg: number of plit bregman iterations
%       nInner: number of inner iterations
%       epsilon: acceptable relative error


%% Create the Lambda tensor
dims = ndims(y);
m = 2;
sizy = size(y);
Lambda = zeros(sizy);
for i = 1:dims
    siz0 = ones(1,dims);
    siz0(i) = sizy(i);
    Lambda = bsxfun(@plus,Lambda,...
        cos(pi*(reshape(1:sizy(i),siz0)-1)/sizy(i)));
end
Lambda = 2*(dims-Lambda);
Gamma = 1./(1+2*s/l*Lambda.^m);

W = isfinite(y);
y(~W) = 0;

z = InitialGuess(y, W);
b = zeros(size(y));
d = zeros(size(y));

error = zeros(nBreg, 1);

nit = 1;
e = epsilon + 1;

if all(W)
    while nit <= nBreg && e >= epsilon

        zPrev = z(:);
        for inner = 1:nInner;
            z = idctn(Gamma .* dctn(d + y - b));
            d = shrink(z-y+b, 1/l);
        end
        b = b + (z - y - d);

        e = norm(zPrev - z(:)) / norm(zPrev);
        error(nit) = log10(e);
        nit = nit + 1;
    end
else
    while nit <= nBreg && e >= epsilon

        zPrev = z(W);
        for inner = 1:nInner;
            z = idctn(Gamma .* dctn(W .* (d + y - b - z) + z));
            u = z-y+b;
            d(W) = shrink(u(W), 1/l);
        end

        u = z - y - d;
        b(W) = b(W) + u(W);

        e = norm(zPrev - z(W)) / norm(zPrev);
        error(nit) = log10(e);
        nit = nit + 1;
    end
end
error = error(1:nit-1);

% disp(['iterations ' int2str(nit-1) '; error ' num2str(error(nit-1))]);

end

function [xs] = shrink(x,lambda)

s = sqrt(x.*conj(x));
ss = s-lambda;
ss = ss.*(ss>0);

s = s+(s<lambda);
ss = ss./s;

xs = ss.*x;

end

%% Initial Guess for missing data
function z = InitialGuess(y,I)
    %-- nearest neighbor interpolation (in case of missing values)
    if any(~I(:))
        if license('test','image_toolbox')
            [~,L] = bwdist(I);
            z = y;
            z(~I) = y(L(~I));
        else
        % If BWDIST does not exist, NaN values are all replaced with the
        % same scalar. The initial guess is not optimal and a warning
        % message thus appears.
            z = y;
            z(~I) = mean(y(I));
            warning('MATLAB:smoothn:InitialGuess',...
                ['BWDIST (Image Processing Toolbox) does not exist. ',...
                'The initial guess may not be optimal; additional',...
                ' iterations can thus be required to ensure complete',...
                ' convergence. Increase ''MaxIter'' criterion if necessary.'])    
        end
    else
        z = y;
    end
    %-- coarse fast smoothing using one-tenth of the DCT coefficients
    siz = size(z);
    z = dctn(z);
    for k = 1:ndims(z)
        z(ceil(siz(k)/10)+1:end,:) = 0;
        z = reshape(z,circshift(siz,[0 1-k]));
        z = shiftdim(z,1);
    end
    z = idctn(z);
end

