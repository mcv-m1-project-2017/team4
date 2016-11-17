function [overlap] = RoiOverlapping(roi01, roi02)
    % RoiOverlapping
    % Defined as Intersection over Union
    %
    %  [overlap] = RoiOverlapping(roi01, roi02)
    %
    %    Parameter name      Value
    %    --------------      -----
    %    'roi1'              First window
    %    'roi2'              Second window
    %
    % Window format is [ struct(x,y,w,h) ; struct(x,y,w,h) ; ... ] in both
    % 
    % The function returns intersection/union for the two windows


    %if length(roi01.x) == 0 || length(roi02.x) == 0,
    %    overlap = 0;
    %    return
    %end

    % Computing the corners of each roi
    roi01x1=roi01.x; roi01x2=roi01.x+roi01.w; roi01y1=roi01.y; roi01y2=roi01.y+roi01.h; 
    roi02x1=roi02.x; roi02x2=roi02.x+roi02.w; roi02y1=roi02.y; roi02y2=roi02.y+roi02.h; 
    
    if roi01x1<roi02x2 && roi01x2>roi02x1 && roi01y1<roi02y2 && roi01y2>roi02y1,
        % intersection
        intersectionX = min( abs(max(roi01x1, roi01x2) - min(roi02x1, roi02x2)) , abs(min(roi01x1, roi01x2) - max(roi02x1, roi02x2)));
        intersectionY = min( abs(max(roi01y1, roi01y2) - min(roi02y1, roi02y2)) , abs(min(roi01y1, roi01y2) - max(roi02y1, roi02y2)));
        intersection = intersectionX*intersectionY;
        
        % union
        roi01Area = (roi01x2-roi01x1) * (roi01y2-roi01y1);
        roi02Area = (roi02x2-roi02x1) * (roi02y2-roi02y1);
        union = (roi01Area+roi02Area) - intersection;
        
        % overlap
        overlap = intersection/union;
    else
        overlap=0;

    end
end
