function [constrainedMask, listBBs] = applyTemplateMatching_train(mask, windowCandidates, path, name)
% APPLYTEMPLATEMATCHING: apply template matching on the
% candidates thresholding based on 'templateMatching_params' values.
%
%   Input parameters
%
%       - filteredMask:         input mask after morphological filtering and geometrical constrains.
%
%       - windowCandidates:     list of bounding boxes of the detections.
%
%       - path:                 file path
%
%       - name:                 image name
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

global corrRes ;
global categories;
load('templateModels.mat');

constrainedMask = mask;
listBBs = windowCandidates;
gtFile = strcat(path, '/gt/gt.', name, 'txt');
[annotations, Signs] = LoadAnnotations(gtFile);
for i = 1:length(annotations)

    x = annotations(i).x;
    y = annotations(i).y;
    w = annotations(i).w;
    h = annotations(i).h;
    [n,m] =  size(mask);
    
    ROI = mask(int32(y):int32(min(y+h,n)), int32(x):int32(min(x+w,m)));
    
    if (sum(ROI(:))>50)
        if (strcmp(Signs{i},'A')==1)
            corrResult = applyTemplateMask (ROI, upTriangModel);
            categories{length(categories)+1} = 'Up Triangular Signal';
            corrRes = [corrRes corrResult];
        elseif strcmp(Signs{i},'B')==1
            corrResult = applyTemplateMask (ROI,downTriangModel);
            categories{length(categories)+1} = 'Down Triangular Signal';
            corrRes = [corrRes corrResult];
        elseif (strcmp(Signs{i},'C')==1)|| (strcmp(Signs{1},'D')==1||(strcmp(Signs{1},'E')==1))
            corrResult = applyTemplateMask (ROI, circularModel);
            categories{length(categories)+1} = 'Circular Signal';
            corrRes = [corrRes corrResult];
        elseif strcmp(Signs{i},'F')==1
            corrResult = applyTemplateMask (ROI, rectModel);
            categories{length(categories)+1} = 'Rectangular Signal';
            corrRes = [corrRes corrResult];
        end
        
    end 
end

end


