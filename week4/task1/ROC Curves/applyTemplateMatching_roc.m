function [constrainedMask, listBBs] = applyTemplateMatching_roc(mask, windowCandidates,threshold, type)
% APPLYTEMPLATEMATCHING: apply template matching on the
% candidates thresholding based on 'templateMatching_params' values.
%
%   Input parameters
%
%       - filteredMask:         input mask after morphological filtering and geometrical constrains.
%
%       - windowCandidates:     list of bounding boxes of the detections.
%
%
%   Output parameters
%
%       - constrainedMask:      image restricted by geometrical conditions.
%
%       - listBBs:              list of bounding boxes of the detections.
%
%       - type:                 type of signal
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
%   Project M1/Block4
%   -----------------


load('templateModels.mat');

constrainedMask = mask;
listBBs = [];
for i = 1:length(windowCandidates)
    x = windowCandidates(i).x;
    y = windowCandidates(i).y;
    w = windowCandidates(i).w;
    h = windowCandidates(i).h;
    [n,m] =  size(mask);
    ROI = mask(int32(y):int32(min(y+h,n)), int32(x):int32(min(x+w,m)));
    if strcmp(type,'circular') ==1
        result= applyTemplateMask (ROI, circularModel);
    elseif strcmp(type,'upTriangular') ==1
        result = applyTemplateMask (ROI, upTriangModel);
    elseif strcmp(type,'downTriangular') ==1
        result = applyTemplateMask (ROI, downTriangModel);
    elseif strcmp(type,'rectangular') ==1
        result = applyTemplateMask (ROI, rectModel);
    end

    condition = (result>threshold);
    if condition
        listBBs = [listBBs windowCandidates(i)];
    else
        constrainedMask(int32(y):int32(min(y+h,n)), int32(x):int32(min(x+w,m))) = 0;
    end
    
    
end
%if isempty(listBBs)
%    listBBs = windowCandidates;
%end

end


