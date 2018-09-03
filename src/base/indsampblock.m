function [Chain, Accept] = indsampblock( ...
    kernelfun, start, block, mu, Sigma, w, s, nIter)
% [Chain, Accept] = indsampblock(kernelfun, start, block, mu, Sigma, w, ...
% s, nIter) samples from a target distribution given its kernel function,
% using the blocked independence sampler.
%
% Input:
% kernelfun - handle to the log-kernel of the target distribution.
% start     - vector of the starting values of the Markov chain.
% block     - cell array where each cell contains a vector of indices of
%             those parameters that form a block.
% mu        - cell array of mean vectors of the multivariate Gaussian
%             proposals of the blocks.
% Sigma     - cell array of covariance matrices of the multivariate Gaussian
%             proposals of the blocks.
% w         - row vector of mixture weights of the mixture of Gaussian
%             conditional proposal distributions of parameter given model
%             (e.g., [0.85, 0.1, 0.05]).
% s         - row vector of scales of the mixture of Gaussian conditional
%             proposal distributions of parameter given model (e.g., [1,
%             10, 100]).
% nIter     - number of MCMC iterations.
%
% Output:
% Chain     - Markov chain of points.
% Accept    - matrix of indicators for whether a move is accepted, where the
%             rows correspond to MCMC iterations, and the columns correspond
%             to blocks.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   June 4, 2014

    % Initialise outputs
    Chain = zeros(nIter, numel(start));
    nBlock = numel(block);
    Accept = zeros(nIter, nBlock);
    
    % First sample
    Chain(1, :) = start;
    Accept(1, :) = 1;
    
    % Evaluate the log-kernel at the initial point
    oldKern = kernelfun(start);
    
    % Evaluate proposal density for each block at the initial point
    oldProp = zeros(nBlock, 1);
    for i = 1:nBlock
        oldProp(i) = log(nmixpdf(start(block{i}), mu{i}, Sigma{i}, w, s));
    end
    
    % For each MCMC iteration
    for i = 2:nIter
        
        % Copy forward the chain
        Chain(i, :) = Chain((i - 1), :);
        
        % For each block
        for j = 1:nBlock
            % Simulate a point from proposal
            subMove = nmixrnd(mu{j}, Sigma{j}, w, s);
            move = Chain(i, :);
            move(block{j}) = subMove;
            
            % Evaluate kernel function
            kern = kernelfun(move);
            
            % Evaluate proposal density
            prop = log(nmixpdf(subMove, mu{j}, Sigma{j}, w, s));
            
            % Compute the log acceptance probability
            left = kern + oldProp(j);
            right = oldKern + prop;
            if isequal(left, right)
                accPr = 0;
            else
                accPr = left - right;
            end
            
            % Accept or reject the block
            if accPr >= 0
                Chain(i, :) = move;
                Accept(i, j) = 1;
                oldKern = kern;
                oldProp(j) = prop;
            elseif log(unifrnd(0, 1)) < accPr
                Chain(i, :) = move;
                Accept(i, j) = 1;
                oldKern = kern;
                oldProp(j) = prop;
            end
        end
    end
end

function x = nmixrnd(mu, Sigma, w, s)
% x = nmixrnd(mu, Sigma, w, s) generates a random number
% from a scale-mixture of normal distributions.
%
% Input:
% mu    - row vector of means,
% Sigma - covariance matrix,
% w     - row vector of mixture weights,
% s     - row vector of scales.

    b = mnrnd(1, w);
    x = mvnrnd(mu, ((b * s') .* Sigma));
end

function y = nmixpdf(x, mu, Sigma, w, s)
% y = nmixpdf(x, mu, Sigma, w, s) computes the density of
% a scale-mixture of normal distributions.
%
% Input:
% x     - a point on the support,
% mu    - row vector of means,
% Sigma - covariance matrix,
% w     - row vector of mixture weights,
% s     - row vector of scales.

    y = 0;
    for i = 1:length(w)
        y = y + (w(i) .* mvnpdf(x, mu, (s(i) .* Sigma)));
    end
end
