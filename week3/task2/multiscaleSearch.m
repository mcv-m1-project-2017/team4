function [ mask ] = multiscaleSearch( image )
% multiscaleSearch: Multi-scale Search over a binary image
%
%% Multi-scale Search algorithm
% 1 Compute LAYERS using gaussian-pyrdamid
% 2 Generate an initial mask (half the size as first LAYER) with '1' values => MASK
% 3 For each LAYER (starting with the smallest one)
%   3.0 Up-scale MASK to match the size the LAYER
%   3.1 Apply MASK to LAYER
%   3.2 Find '1' pixels => PIXEL CANDIDATEs
%   3.3 For each PIXEL CANDIDATE
%     - Is the region centered on that pixel is a traffic sign ? [CancellingMaskAlgorithm]
%       TRUE: Update cancelling mask for region removal => MASK
%       FALSE: do nothing
%   3.4 Return MASK
% (4) Apply MASK to original mask layer [this operation is perfomed outside this function]
%
%% Cancelling Mask algorithm (given MASK,PIXEL CANDIDATE,WINDOW)
% 1 Build a matrix of ones with the same size as the current LAYER => MASK
% 2 Insert the (negated) WINDOW centered in the pixel candidate of this MASK => MASK
% 3 Return MASK
% NOTE this algorithm can be improved removing pixel candidates while removing region
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1
mask = image;

end  % multiscaleSearch
