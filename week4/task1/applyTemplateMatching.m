function [constrainedMask, listBBs] = applyTemplateMatching(mask, windowCandidates)
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
    upTriangResult = applyTemplateMask (ROI, upTriangModel);
    downTriangResult = applyTemplateMask (ROI, downTriangModel);
    circularResult = applyTemplateMask (ROI, circularModel);
    rectResult = applyTemplateMask (ROI, rectModel);

    condition = ((upTriangResult>0.63)||(downTriangResult>0.7)||(circularResult>0.32)||(rectResult>0.37));
    if condition
        listBBs = [listBBs windowCandidates(i)];
    else
        constrainedMask(int32(y):int32(min(y+h,n)), int32(x):int32(min(x+w,m))) = 0;
    end
    
    
end
if isempty(listBBs)
    listBBs = windowCandidates;
end

end


