function [constrainedMask] = method5_geometricalConstraints(filteredMask, geometricFeatures,idx)
CC = bwconncomp(filteredMask);
CC_stats = regionprops(CC, 'Area', 'BoundingBox');

if (isempty(CC_stats))
    % Can't restrict on area, filling or form factor, mask done, return
    % leave input mask unchanged (the mask already was blank)
    constrainedMask = filteredMask;
else
    areaCC = [CC_stats.Area]';
    BBs = vertcat(CC_stats.BoundingBox);
    areasBB = BBs(:,3).*BBs(:,4);
    fillRatioCC = (areaCC./areasBB);
    formFactorCC = BBs(:,3)./BBs(:,4);
    
    % --------Geometric features----------
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
    
    % Define factors to fine-tune thresholds (vectors to try different
    % values)
    % Area
    A_min = 0.925;  A_max = 1.175;  % Start with tested ones. [0.75,1.25]
    
    % Aspect ratio:
    AR_scaleStd = 3;          % AR_scaleStd = [2,2.5,3,3.5]
    
    % Filling factor
    % Triangular
    FF_tri_scaleStd = 2.5;        % FF_tri_scaleStd = [1,1.5,2,2.5]
    % Circular
    FF_circ_scaleStd = 2.5;       % FF_circ_scaleStd = [1,1.5,2,2.5]
    % Rectangular
    FF_rect_scaleStd = 2.5;       % FF_rect_scaleStd = [2,2.5,3,3.5]
    
    
    % ------- APPLY THRESHOLDS-------------
    % Area min/max
    % Aspect ratio/form factor mean+-std
    % FF=> for each shape: mean+-std
    
    outIdx = find((areaCC > A_min(idx)*minArea & areaCC < A_max(idx)*maxArea) &...
        (formFactorCC > meanFormFactor - AR_scaleStd(idx)*stdFormFactor &...
        formFactorCC < meanFormFactor + AR_scaleStd(idx)*stdFormFactor) &...
        ((fillRatioCC > meanFillingRatio_tri - FF_tri_scaleStd(idx)*stdFillingRatio_tri &...
        fillRatioCC < meanFillingRatio_tri + FF_tri_scaleStd(idx)*stdFillingRatio_tri) |...
        (fillRatioCC > meanFillingRatio_circ - FF_circ_scaleStd(idx)*stdFillingRatio_circ &...
        fillRatioCC < meanFillingRatio_circ + FF_circ_scaleStd(idx)*stdFillingRatio_circ) |...
        fillRatioCC > meanFillingRatio_rect - FF_rect_scaleStd(idx)*stdFillingRatio_rect &...
        fillRatioCC < meanFillingRatio_rect + FF_rect_scaleStd(idx)*stdFillingRatio_rect));
    
    % Only retain those CC that fulfil the above conditions
    if(isempty(outIdx)) % We have erased any possible detection, revert
        % back to the morphological filtered output
        constrainedMask = filteredMask;
    else
        constrainedMask = ismember(labelmatrix(CC), outIdx);
    end
    
end

%% Testing results:
% Method 5 + max and min area constraints
% pixelPrecision; pixelAccuracy; pixelRecall; Fmeasure; pixelTP; pixelFP; pixelFN; timePerFrame
%    0.2890         0.9911          0.8291    0.4286    0.0033    0.0082    0.0007  0.6325
% Non-optimized threshold for area, FF, AR:
% ----------------------------------------------------
% pixelPrecision; pixelAccuracy; pixelRecall; Fmeasure; pixelTP; pixelFP; pixelFN; timePerFrame
% 0.3241 	 0.9929 	    0.6947 	    0.4420 	   0.0028 	 0.0058   0.0012 	 0.5555

end