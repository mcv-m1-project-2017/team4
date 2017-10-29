function [constrainedMask, listBBs, isSignal] = applyGeometricalConstraints(filteredMask,...
    CC, CC_stats, geometricFeatures, params)
% APPLYGEOMETRICALCONSTRAINTS: apply geometrical constraint on the
% structure of region props 'CC_stats' by thresholding based on
% 'geometricFeatures' and 'params' values.
%
%   Input parameters
%
%       - filteredMask:         input mask after morphological filtering.
%
%       - CC:                   connected components (with increasing
%                               labels '1', '2', up to the 'N' connected
%                               components found in the image.
%
%       - CC_stats:             structure of connected components region
%                               props (from 'regionprops' function with 'Area'
%                               and 'BoundingBox' properties)
%
%       - geometricFeatures:    vector of geometric features loaded from
%                               'GeometricFeatures_train.mat'.
%
%       - params:               scale parameters to fine-tune thresholds.
%
%   Output parameters
%
%       - constrainedMask:      image restricted by geometrical conditions.
%
%       - listBBs:              list of bounding boxes of the detections.
%
%       - isSignal:             vector of 1's and 0's (signal/not signal).
%
%
%   AUTHORS
%   -------
%   Jonatan Poveda
%   Martí Cobos
%   Juan Francesc Serracant
%   Ferran Pérez
%   Master in Computer Vision
%   Computer Vision Center, Barcelona
%
%   Project M1/Block3
%   -----------------

%% Allocate outputs and check if any CC have been detected
listBBs = struct([]);
isSignal = zeros(size(CC_stats,1), 1);
if (isempty(CC_stats))
    % Can't restrict on area, filling or form factor, blank mask.
    constrainedMask = filteredMask;
    % Leave listBBs as empty (no detection, blank image).
    % isSignal will also be zeros(0,1) which is []
    
    % Display a warning
    warning('The input filtered segmentation mask was empty! exiting function,..\n');
else
    %% Compute CC area, form factor (aspect ratio) and filling ratio
    areaCC = [CC_stats.Area]';
    BBs = vertcat(CC_stats.BoundingBox);
    areasBB = BBs(:,3).*BBs(:,4);
    fillRatioCC = (areaCC./areasBB);
    formFactorCC = BBs(:,3)./BBs(:,4);
    
    %% Load train' geometric features on which the thresholds are based
    
    % Area
    minArea = geometricFeatures(1);
    maxArea = geometricFeatures(2);
    meanArea = geometricFeatures(3);
    stdArea = geometricFeatures(4);
    
    % Aspect ratio/form factor
    minFormFactor = geometricFeatures(5);
    maxFormFactor = geometricFeatures(6);
    meanFormFactor = geometricFeatures(7);
    stdFormFactor = geometricFeatures(8);
    
    % Filling ratio
    % Triangular signals
    minFillingRatio_tri = geometricFeatures(9);
    maxFillingRatio_tri = geometricFeatures(10);
    meanFillingRatio_tri = geometricFeatures(11);
    stdFillingRatio_tri = geometricFeatures(12);
    
    % Circular/round signals
    minFillingRatio_circ = geometricFeatures(13);
    maxFillingRatio_circ = geometricFeatures(14);
    meanFillingRatio_circ = geometricFeatures(15);
    stdFillingRatio_circ = geometricFeatures(16);
    
    % Rectangular signals
    minFillingRatio_rect = geometricFeatures(17);
    maxFillingRatio_rect = geometricFeatures(18);
    meanFillingRatio_rect = geometricFeatures(19);
    stdFillingRatio_rect = geometricFeatures(20);
    
    %% Define scaling factors for the thresholds loaded above
    
    % Area
    A_min = params(1);
    A_max = params(2);
    
    % Aspect ratio:
    AR_scaleStd = params(3);
    
    % Filling factor
    % Triangular
    FF_tri_scaleStd = params(4);
    % Circular
    FF_circ_scaleStd = params(5);
    % Rectangular
    FF_rect_scaleStd = params(6);
    
    %% Apply the thresholding and retain only CC's that fulfil them
    
    % Models used:
    % Area ==> values between min/max
    % Aspect ratio/form factor ==>  in the range: mean +- X*std
    % FF (for each shape) ==> in the range: mean +- X*std
    
    outIdx = find((areaCC > A_min*minArea & areaCC < A_max*maxArea) &...
        (formFactorCC > meanFormFactor - AR_scaleStd*stdFormFactor &...
        formFactorCC < meanFormFactor + AR_scaleStd*stdFormFactor) &...
        ((fillRatioCC > meanFillingRatio_tri - FF_tri_scaleStd*stdFillingRatio_tri &...
        fillRatioCC < meanFillingRatio_tri + FF_tri_scaleStd*stdFillingRatio_tri) |...
        (fillRatioCC > meanFillingRatio_circ - FF_circ_scaleStd*stdFillingRatio_circ &...
        fillRatioCC < meanFillingRatio_circ + FF_circ_scaleStd*stdFillingRatio_circ) |...
        fillRatioCC > meanFillingRatio_rect - FF_rect_scaleStd*stdFillingRatio_rect &...
        fillRatioCC < meanFillingRatio_rect + FF_rect_scaleStd*stdFillingRatio_rect));
    
    % Only retain those CC that fulfil the above conditions
    if(isempty(outIdx)) % We have erased any possible detection, revert
        % back to the morphological filtered output
        constrainedMask = filteredMask;
        % Generate output struct with the following format:
        % fields: 'x', 'y', 'w' and 'h' (top-left x & y, width and height)
        % One line per CC
        [listBBs] = createListOfWindows(CC_stats);
        % 'reverting' is equal to saying that I believe my detections can
        % be signal, hence isSignal = 1 for those CC idx'.
        isSignal(:, 1) = 1;
    else
        constrainedMask = ismember(labelmatrix(CC), outIdx);
        
        % Compute new CCs for 'constrainedMask'
        CC_constrMask = bwconncomp(constrainedMask);
        CC_constrMask_stats = regionprops(CC_constrMask, 'BoundingBox');
        % Generate output structure (I cannot think of a method w/o for loop..)
        [listBBs] = createListOfWindows(CC_constrMask_stats);
        % Only the CC with indices in the outIdx are believed to be signals
        isSignal(outIdx, 1) = 1;
    end
end