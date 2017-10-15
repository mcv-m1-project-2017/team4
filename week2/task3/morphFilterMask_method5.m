function [filteredMask]= morphFilterMask_method5(mask, fillFormArea_stats)%, maxthr_val, minthr_val)%listParams)
%{
Jonatan Poveda
Martí Cobos
Juan Francesc Serracant
Ferran Pérez
Master in Computer Vision
Computer Vision Center, Barcelona
---------------------------
Project M1/Block2
---------------------------
This function is used to apply morphological operators to a mask segmented by color.
input: - mask: the input mask to be filtered
output:- filteredMmask: the masks filtered with morphological operators from the input mask
---------------------------
%}
% List of params contains the parameter values for iteration 'p' (see
% morphFilterMask_method4_test for more info.

%Filter small pixels out of bright or dark areas (noise filtering)
SE = strel('disk',3);
filteredMask = imopen(mask, SE);
filteredMask = imclose(filteredMask, SE);

%Close triangular signals
% SE = strel('diamond',30);
% filteredMask = imclose(filteredMask, SE);
filteredMask = imfill(filteredMask, 'holes');
filteredMask = imclose(filteredMask, strel('disk',30));


%Filter big pixels out of bright or dark areas (second noise filtering)
%SE = strel('disk',5); %7-> recall 75
SE_open = strel('disk', 5);%listParams(1));
SE_close = strel('disk', 5);%listParams(2));
filteredMask = imopen(filteredMask, SE_open);
filteredMask = imclose(filteredMask, SE_close);

% Hole filling the final selection
% filteredMask = imfill(filteredMask, 'holes');

% Close +  dilation to enlarge the detection as signals
SE_lastClose = strel('disk',20);%listParams(3));
SE_dilation = strel('disk',3);%listParams(4));
filteredMask = imclose(filteredMask, SE_lastClose); % maybe not worth it
filteredMask = imfill(filteredMask, 'holes');
filteredMask = imdilate(filteredMask, SE_dilation);

% Add maximum filter size for the detected signals:
% VERY IMPORTANT: we need to consider that there may be more than one
% signal per frame so we have to compute the connected regions and measure
% its area and comparing to the max threshold, if it is above the
% threshold, convert all pixels to black
% The time per frame may increase considerably depending on the size and
% number of connected regions (candidates).
CC = bwconncomp(filteredMask);
CC_stats = regionprops(CC, 'Area', 'BoundingBox');

if (isempty(CC_stats))
    % Can't restrict on area, filling or form factor, mask done.
else
    BBs = vertcat(CC_stats.BoundingBox);
    areasBB = BBs(:,3).*BBs(:,4);
    fillRatio = (areasBB./[CC_stats.Area]');
    formFactor = BBs(:,3)./BBs(:,4);
%     
    % MAX / MIN AREA
    maxSignalArea = fillFormArea_stats(1); % Min->2, mean->3 and std->4
    minSignalArea = fillFormArea_stats(2);
    
    % MAX/MIN FILLING RATIO
    maxFillingRatio = fillFormArea_stats(5);
    minFillingRatio = fillFormArea_stats(6);
%     
%     % MAX/MIN FORM FACTOR
    maxFormFactor = fillFormArea_stats(9);
    minFormFactor = fillFormArea_stats(10);
    
    % ------- TEST WITH MAX()
    % Filter by max size (we could easily add more restrictions by computing
    % and using more regionprops):
    % --Still needs testing to achieve optimal maxs and mins for form factor
    % and filling ratio------------
    % Candidate thresholds:
    
    idx = find([CC_stats.Area] < 1.175 * maxSignalArea &...
        [CC_stats.Area] > 0.925 * minSignalArea &...
        fillRatio < 0.8*maxFillingRatio & fillRatio > 0.8*minFillingRatio &...
        formFactor < 0.8*maxFormFactor & formFactor > 0.8*minFormFactor); % Find CC idx that fulfil this
    filteredMask = ismember(labelmatrix(CC), idx);
    
end
%---TEST WITH MEAN + x*STD? (if max is too restrictive and does not erase
% FP.
% OR/and add a min threshold as well
%% Current results (as of 15/09/2017 14:13 AM
% (pixelPrecision; pixelAccuracy; pixelRecall; Fmeasure; pixelTP; pixelFP; pixelFN; timePerFrame)
% 0.2698    0.9910    0.7848    0.4015    0.0030    0.0082    0.0008    0.3849
% Commenting imdilate and uncommenting imclose above
% Reverse process (dilate instead of close) yields better results:
% (pixelPrecision; pixelAccuracy; pixelRecall; Fmeasure; pixelTP; pixelFP; pixelFN; timePerFrame)
%       0.2509          0.9898    0.8262    0.3849    0.0032    0.0095    0.0007    0.3493
% Both active (last close + dilation), slightly better results, not worth
% the extra 59.8ms (for a recall only 0.0010 (0.1% higher))
% (pixelPrecision; pixelAccuracy; pixelRecall; Fmeasure; pixelTP; pixelFP; pixelFN; timePerFrame)
%       0.2495          0.9897    0.8272    0.3834    0.0032    0.0096    0.0007    0.4091
% Results with 1.2*max_area threshold:
% (pixelPrecision; pixelAccuracy; pixelRecall; Fmeasure; pixelTP; pixelFP; pixelFN; timePerFrame)
%       0.2653          0.9900    0.8342    0.4026    0.0034    0.0093    0.0007    0.5430

% With max on every parameter, better precision worst recall
% 0.5084    0.9962    0.4210    0.4606    0.0016    0.0016    0.0022 0.6577
% Only max on area:
% Algorithm results: 
% pixelPrecision; pixelAccuracy; pixelRecall; Fmeasure; pixelTP; pixelFP; pixelFN; timePerFrame
%    0.2890         0.9911          0.8291    0.4286    0.0033    0.0082    0.0007  0.6325

end