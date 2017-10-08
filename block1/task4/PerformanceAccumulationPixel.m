function [pixelTP, pixelFP, pixelFN, pixelTN] = PerformanceAccumulationPixel(pixelCandidates, pixelAnnotation)
    % PerformanceAccumulationPixel
    % Function to compute different performance indicators 
    % (True Positive, False Positive, False Negative, True Negative) 
    % at the pixel level
    %
    % [pixelTP, pixelFP, pixelFN, pixelTN] = PerformanceAccumulationPixel(pixelCandidates, pixelAnnotation)
    %
    %    Parameter name      Value
    %    --------------      -----
    %    'pixelCandidates'   Binary image marking the detected areas
    %    'pixelAnnotation'   Binary image containing ground truth
    %
    % The function returns the number of True Positive (pixelTP), False Positive (pixelFP), 
    % False Negative (pixelFN) and True Negative (pixelTN) pixels in the image pixelCandidates

    pixelCandidates = pixelCandidates>0;
    pixelAnnotation = pixelAnnotation>0;
    
    pixelTP = sum(sum(pixelCandidates>0 & pixelAnnotation>0));
    pixelFP = sum(sum(pixelCandidates>0 & pixelAnnotation==0));
    pixelFN = sum(sum(pixelCandidates==0 & pixelAnnotation>0));
    pixelTN = sum(sum(pixelCandidates==0 & pixelAnnotation==0));
end
