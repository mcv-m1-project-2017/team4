%% Test watershed regions + HSV colour segmentation to improve masks
function [outputMask, windowCandidates] = watershed_hsvColourSegmentation(RGB_image, geometricFeatures, params)

% Call watershed and compute regions:
gradientType = 'sobel';
[watershedRegions, CC_stats_WS] = watershedSegmentation(RGB_image, gradientType, geometricFeatures);


% CANNOT DO THIS ==> THERE ARE REGIONS ALL OVER THE IMAGE
% % Little line to close very close signals that may be open
% se = strel('line', 3, 0); % 3 pixels, 0 degree
% 
% improvedWatershedRegions = imclose(watershedRegions > 0, se);

% Get CC bounding box to apply independently HSV colour segmentation only
% to watershed-retrieved regions:

% Get watershed number of regions:
WS_numRegions = size(CC_stats_WS,1);

outputMask = zeros(size(RGB_image,1), size(RGB_image,2));
for i = 1: WS_numRegions
   % Compute HSV colour segmentation of the region crop
   topLeftX = CC_stats_WS(i).BoundingBox(1);
   topLeftY = CC_stats_WS(i).BoundingBox(2);
   width = CC_stats_WS(i).BoundingBox(3);
   height = CC_stats_WS(i).BoundingBox(4);
   %rgb_regionCrop = imcrop(RGB_image, [topLeftX, topLeftY, width, height]);
   [h,w,~] = size(RGB_image);
   ymin = min(uint32(topLeftY),h);
   ymax = min(uint32(topLeftY + height),h);
   xmin = min(uint32(topLeftX),w);
   xmax = min(uint32(topLeftX + width),w);
   rgb_regionCrop = RGB_image(ymin:ymax ,xmin:xmax ,:);
   
   regionColourMask = colorSegmentation(rgb_regionCrop);
   % Copy result to output mask (for pixel-based evaluation and also to only
   % retrieve useful windows for window-based evaluation)
   outputMask( ymin:ymax ,xmin:xmax) =regionColourMask;
  % outputMask(topLeftX: topLeftX + width,...
   %    topLeftY: topLeftY + height) = regionColourMask;
end

% Compute CC and regionprops

[~, CC_stats] = computeCC_regionProps(outputMask);
[windowCandidates] = createListOfWindows(CC_stats);