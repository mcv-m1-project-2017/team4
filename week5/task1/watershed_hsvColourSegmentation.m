%% Test watershed regions + HSV colour segmentation to improve masks
function [outputMask, windowCandidates] = watershed_hsvColourSegmentation(RGB_image, geometricFeatures, params, minOverlap, minArea)

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
discarded = 0;

% Initialize output variables
windowCandidates = struct('x', [], 'y', [], 'w', [], 'h', []);
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
    % Use the bounding box of 'regionColourMask' as the
    % 'windowCandidate' and filter them regarding size
    
    % ADD A THRESHOLD BASED ON THE % OF WHITE PIXELS IN THE MASK
    % Those who are from a watershed region AND also fulfil HSV conditions
    % This condition is useful only for window-based processing
    ok_pixels = sum(regionColourMask(:));
    bb_area = width * height;
    ok_percentage = ok_pixels/bb_area;
    
    if (ok_percentage >= minOverlap) % Consider the CC's in the window as
        % candidates and compute their BBs
        % Apply geometrical constraints on AR (beware, this could be too
        % strict). Remove it if the results are bad.
        
        % Before: filter very small CC's (remember that TP may still be
        % empty (no hole filling applied w/o morphology))
        regionColourMask = bwareaopen(regionColourMask, minArea, 4);
        [CC, CC_stats] = computeCC_regionProps(regionColourMask);
        [regionColourMask, tempWindowCandidate, ~] =...
            applyGeometricalConstraints(regionColourMask, CC, CC_stats,...
            geometricFeatures, params, 1);
        outputMask(ymin:ymax ,xmin:xmax) = regionColourMask;
        
        % ATTENTION: correct BB x and y coordinates! computed with respect
        % to the origin of the region not the whole image! Change 'x' and
        % 'y' fields for 'topLeftX+tmpX' and 'topLeftY+tmpY'
%         if (size(tempWindowCandidate,1) > 1  || size(windowCandidates,1) > 1)
%             fprintf('debug here');
%         end
        
        if(~isempty(tempWindowCandidate))
            for c = 1: size(tempWindowCandidate,1)
                % Make sure we do not go out of bounds by mistake
                if (tempWindowCandidate(c).w * tempWindowCandidate(c).h < 25)
                    continue;
                end
                tempWindowCandidate(c).x = min(topLeftX + tempWindowCandidate(c).x-1, size(RGB_image,2));
                tempWindowCandidate(c).y = min(topLeftY + tempWindowCandidate(c).y-1, size(RGB_image,1));
                
                % Concatenate previous image regions that fulfil criterion
                WC_rows = size(windowCandidates,1);
                if (WC_rows > 1)
                    windowCandidates(WC_rows+1+c).x = tempWindowCandidate(c).x;
                    windowCandidates(WC_rows+1+c).y = tempWindowCandidate(c).y;
                    windowCandidates(WC_rows+1+c).w = tempWindowCandidate(c).w;
                    windowCandidates(WC_rows+1+c).h = tempWindowCandidate(c).h;
                else
                    if (isempty(windowCandidates(WC_rows).x) || ...
                            isempty(windowCandidates(WC_rows).y)...
                            || isempty(windowCandidates(WC_rows).w)...
                            || isempty(windowCandidates(WC_rows).h))
                        % First addition
                        windowCandidates(1).x = tempWindowCandidate(c).x;
                        windowCandidates(1).y = tempWindowCandidate(c).y;
                        windowCandidates(1).w = tempWindowCandidate(c).w;
                        windowCandidates(1).h = tempWindowCandidate(c).h;
                    else    % Second addition
                        windowCandidates(2).x = tempWindowCandidate(c).x;
                        windowCandidates(2).y = tempWindowCandidate(c).y;
                        windowCandidates(2).w = tempWindowCandidate(c).w;
                        windowCandidates(2).h = tempWindowCandidate(c).h;
                    end
                end
            end
        end   
            
        else % Do not consider the CC's inside the watershed region, do nothing
            % fprintf('Region num. %d discarded (overlap < thr.)\n', i); %
            % DEBUG ONLY (line above)
            % For pixel-based evaluation
            discarded = discarded +1;
            outputMask(ymin:ymax ,xmin:xmax) = regionColourMask;
            
        end
        
        
        
end
fprintf('Discarded %d regions of %d==> %.2f%%\n', discarded,...
    WS_numRegions, (discarded/WS_numRegions)*100);

% Compute CC and regionprops

% [~, CC_stats] = computeCC_regionProps(outputMask);
% [windowCandidates] = createListOfWindows(CC_stats);