function [area, FF, FR, hueHist,topWidthRel ] = getROIDescriptors(ROIMask, ROIhsv)
%{
Jonatan Poveda
Martí Cobos
Juan Francesc Serracant
Ferran Pérez
Master in Computer Vision
Computer Vision Center, Barcelona
---------------------------
Project M1/Block2Week3
----------------
This function is used to compute an image granulometry.
input:  - ROIMask: input mask to analyze if there is a signal
        - ROIhsv: input ROI in HSV color space       
output: - size: signal Area
        - FF: form factor (width/height)
        - FR: filling ratio (mask area / bounding box area)
        - hueHist: signal hue hitogram without white color
        - topWidthRel Relation between the topb width and the BB width
---------------------------
%}
%define characteristics parameters
nBins = 50;
sWhiteThreshold = 0.5;
ROIRel = 5 ;

%Compute size, FR and FF
[height,width] = size(ROIMask);
area = sum(ROIMask(:));
boundingBoxArea=height*width;
FR = height/width;
FF = area/boundingBoxArea;

%Compute color histogram
h = ROIhsv(:,:,1).*360;
s = ROIhsv(:,:,2);
hMask = (ROIMask == 1)&(s > sWhiteThreshold);
bins = linspace(0,360,nBins+1);
hueHist = histogram(h(hMask), bins, 'Normalization','probability');
close all;

%Compute relation of upper mask width and mas width
croppedROI = ROIMask(1:int32(height/ROIRel),:);
stats = regionprops(croppedROI,'BoundingBox');
topWidthRel=(stats.BoundingBox(3))/width;

end

