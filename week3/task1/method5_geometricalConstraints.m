function [constrainedMask, listBBs] = method5_geometricalConstraints(filteredMask,...
    geometricFeatures, params)
% Initialize output list of BBs as empty
listBBs = [];
CC = bwconncomp(filteredMask);
CC_stats = regionprops(CC, 'Area', 'BoundingBox');

if (isempty(CC_stats))
    % Can't restrict on area, filling or form factor, mask done, return
    % leave input mask unchanged (the mask already was blank)
    constrainedMask = filteredMask;
    % Leave listBBs as empty (no detection, blank image).
    warning('The input filtered segmentation mask was empty! exiting function,..\n');
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
    A_min = params(1);%0.925;%minArea;%1.8;%minArea;%0.925;  A_max = 1.175;  % Start with tested ones. [0.75,1.25]
    A_max = params(2);%1.175;%maxArea;%1.175;%maxArea;
    % Aspect ratio:
    AR_scaleStd = params(3);%3;%stdAR; %3;          % AR_scaleStd = [2,2.5,3,3.5]
    
    % Filling factor
    % Triangular
    FF_tri_scaleStd = params(4);%4.5;%testFR_tri;%[4.5, 4 .75, 5];        % FF_tri_scaleStd = [1,1.5,2,2.5]
    % Circular
    FF_circ_scaleStd = params(5);%4.5;%testFR_circ;%[4.5, 4.75;       % FF_circ_scaleStd = [1,1.5,2,2.5]
    % Rectangular
    FF_rect_scaleStd = params(6);%4.5;%testFR_rect;%4.5;       % FF_rect_scaleStd = [2,2.5,3,3.5]
    
    
    % ------- APPLY THRESHOLDS-------------
    % Area min/max
    % Aspect ratio/form factor mean+-std
    % FF=> for each shape: mean+-std
    
    outIdx = find((areaCC > A_min*minArea & areaCC < A_max*maxArea) &...
        (formFactorCC > meanFormFactor - AR_scaleStd*stdFormFactor &...
        formFactorCC < meanFormFactor + AR_scaleStd*stdFormFactor) &...
        ((fillRatioCC > meanFillingRatio_tri - FF_tri_scaleStd*stdFillingRatio_tri &...
        fillRatioCC < meanFillingRatio_tri + FF_tri_scaleStd*stdFillingRatio_tri) |...
        (fillRatioCC > meanFillingRatio_circ - FF_circ_scaleStd*stdFillingRatio_circ &...
        fillRatioCC < meanFillingRatio_circ + FF_circ_scaleStd*stdFillingRatio_circ) |...
        fillRatioCC > meanFillingRatio_rect - FF_rect_scaleStd*stdFillingRatio_rect &...
        fillRatioCC < meanFillingRatio_rect + FF_rect_scaleStd*stdFillingRatio_rect));
    
    % Only retain those CC that fulfil the above conditions
    if(isempty(outIdx)) % We have erased any possible detection, revert
        % back to the morphological filtered output
        constrainedMask = filteredMask;
        % Generate output structure 
        for cc = 1:size(CC_stats,1)
            listBBs = [listBBs, mat2cell(CC_stats(cc).BoundingBox, 1, 4)];
        end
    else
        constrainedMask = ismember(labelmatrix(CC), outIdx);
        
        % Compute new CCs for 'constrainedMask'
        CC_constrMask = bwconncomp(constrainedMask);
        CC_constrMask_stats = regionprops(CC_constrMask, 'BoundingBox');
        % Generate output structure (I cannot think of a method w/o for loop..)
        for cc = 1:size(CC_constrMask_stats,1)
            listBBs = [listBBs, mat2cell(CC_constrMask_stats(cc).BoundingBox, 1, 4)];
        end
        
    end
    
    %% Testing results:
    % VALIDATION
    % Method 5 + max and min area constraints
    % pixelPrecision; pixelAccuracy; pixelRecall; Fmeasure; pixelTP; pixelFP; pixelFN; timePerFrame
    %    0.2890         0.9911          0.8291    0.4286    0.0033    0.0082    0.0007  0.6325
    % Non-optimized threshold for area, FF, AR:
    % Threshold factor values:
    % A_min = 0.925;  A_max = 1.175;
    % AR_scaleStd = 3;
    % FF_tri_scaleStd = 2.5;
    % FF_circ_scaleStd = 2.5;
    % FF_rect_scaleStd = 2.5;
    % ----------------------------------------------------
    % VALIDATION
    % pixelPrecision; pixelAccuracy; pixelRecall; Fmeasure; pixelTP; pixelFP; pixelFN; timePerFrame
    % 0.3241 	 0.9929 	    0.6947 	    0.4420 	   0.0028 	 0.0058   0.0012 	 0.5555
    %
    % IF NOT SPECIFIED WITH 'VALIDATION', THE RESULTS ARE FOR 'TRAINING'
    % Non-optimized threshold for area, FF, AR (II):
    % ----------------------------------------------------
    % A_min = 0.925;  A_max = 1.175;
    % AR_scaleStd = 3;
    % FF_tri_scaleStd = 3;
    % FF_circ_scaleStd = 2.5;
    % FF_rect_scaleStd = 2.5;
    %
    % pixelPrecision; pixelAccuracy; pixelRecall; Fmeasure; pixelTP; pixelFP; pixelFN; timePerFrame
    %     0.3989      0.9946           0.6951      0.5069   0.0028 	 0.0042    0.0012 	 0.5284
    %
    % Non-optimized threshold for area, FF, AR (III)
    %
    % A_min = 0.925;  A_max = 1.175;
    % AR_scaleStd = 3;
    % FF_tri_scaleStd = 3;
    % FF_circ_scaleStd = 2.5;
    % FF_rect_scaleStd = 3;
    %
    % Prm. ==> Precision; 	 Accuracy; 	 Recall; 	 Fmeasure; 	 pixelTP; 	 pixelFP; 	 pixelFN; 	 timexFrame
    % Res. ==> 0.3989 	 0.9946 	 0.6951 	 0.5069 	 0.0028 	 0.0042 	 0.0012 	 0.5407
    %
    % Method 1 + geometric constraints
    % A_min = 0.925;  A_max = 1.175;
    % AR_scaleStd = 3;
    % FF_tri_scaleStd = 3;
    % FF_circ_scaleStd = 3;
    % FF_rect_scaleStd = 3;
    %
    % ----------------------------------------------------
    % Prm. ==> Precision; 	 Accuracy; 	 Recall; 	 Fmeasure; 	 pixelTP; 	 pixelFP; 	 pixelFN; 	 timexFrame
    % Res. ==> 0.6616 	 0.9972 	 0.6425 	 0.6519 	 0.0026 	 0.0013 	 0.0014 	 0.2049
    %
    % Same as above but adding a open/close disk 3 before imfill and big open
    % color mask ==> open3disk ==> close3disk ==> imfill ==> close20 square
    % Worse results (seems simpler it's better)
    % ----------------------------------------------------
    % Prm. ==> Precision; 	 Accuracy; 	 Recall; 	 Fmeasure; 	 pixelTP; 	 pixelFP; 	 pixelFN; 	 timexFrame
    % Res. ==> 0.6336 	 0.9969 	 0.5494 	 0.5885 	 0.0022 	 0.0013 	 0.0018 	 0.3302
    %
    % What about putting first the imfill and then doing the denoising?
    % Worse too (more balanced P, R)
    % ----------------------------------------------------
    % Prm. ==> Precision; 	 Accuracy; 	 Recall; 	 Fmeasure; 	 pixelTP; 	 pixelFP; 	 pixelFN; 	 timexFrame
    % Res. ==> 0.6291 	 0.9970 	 0.6271 	 0.6281 	 0.0025 	 0.0015 	 0.0015 	 0.3401
    %
    % Method 1 + extra close disk 15
    % Worse, does not help, it lowers the precision by introducing more FPs
    % ----------------------------------------------------
    % Prm. ==> Precision; 	 Accuracy; 	 Recall; 	 Fmeasure; 	 pixelTP; 	 pixelFP; 	 pixelFN; 	 timexFrame
    % Res. ==> 0.6259 	 0.9970 	 0.6524 	 0.6389 	 0.0026 	 0.0016 	 0.0014 	 0.3042
    %
    % Method 1 but everything set to 3 in FR: more permissive=> lower FN,
    % though higher FP
    % Better! However, we maintain a very similar ratio of FP and FN (although
    % the TP increase slightly)
    % ----------------------------------------------------
    % Prm. ==> Precision; 	 Accuracy; 	 Recall; 	 Fmeasure; 	 pixelTP; 	 pixelFP; 	 pixelFN; 	 timexFrame
    % Res. ==> 0.6906 	 0.9975 	 0.6687 	 0.6795 	 0.0027 	 0.0012 	 0.0013 	 0.2037
    %
    % What about being even less restrictive? set all FR to 4
    % Given that we have computed the data from the training to implement the
    % thresholds, this should improve the results here but MAYBE reduce
    % performance in validation, this must be checked once a good value in
    % training is achieved (to avoid overfitting).
    % OK, better overall but the precision is trying to slightly decrease again
    % because we have introduce more FP's! Watch out! However, we value
    % slightly more the recall (we have always the opportunity to remove a
    % signals but if we have deleted it, no change on recovering it).
    % ----------------------------------------------------
    % Prm. ==> Precision; 	 Accuracy; 	 Recall; 	 Fmeasure; 	 pixelTP; 	 pixelFP; 	 pixelFN; 	 timexFrame
    % Res. ==> 0.6807 	 0.9975 	 0.7272 	 0.7032 	 0.0029 	 0.0014 	 0.0011 	 0.2122
    %
    % Let's check 5 just to be sure of the tendency observed for the previous
    % case(it will probably be too much and the FR will be too permissive).
    %
    % And there you go, the limit, almost same recall, worse precision and
    % fscore with more FP's and similar ratio of FN, dial it back to 4.5 and
    % see what happens. If not, 4 is fine (although we should keep trying more
    % values.
    % ----------------------------------------------------
    % Prm. ==> Precision; 	 Accuracy; 	 Recall; 	 Fmeasure; 	 pixelTP; 	 pixelFP; 	 pixelFN; 	 timexFrame
    % Res. ==> 0.6655 	 0.9974 	 0.7250 	 0.6940 	 0.0029 	 0.0015 	 0.0011 	 0.2134
    %
    % 4.5?
    % No need to copy it, same results as above (EXACTLY), 4 it is (for now).
    % It is very likely that each shape has a slightly different optimal
    % threshold and we will test that in due time!
    %
    % NEXT STEPS, IDEAS:
    %   - Opening by reconstruction of erosion as the marker (test some images)
    %   - See what results are obtained without FR thresholds(worse probably?)
    %       - Worse indeed, similar to the result above with 4.5 or
    %       - This may indicate that the aspect ratio threshold is not doing
    %       much (or it is?) Check it
    %       -(result)
    %   - Check improvements to the morphological part, slight tweaks:
    %       - No noise removal step, maybe at the end? (at the beginning didn't
    %       work). Only with a close 'cause the big open already covers the
    %       'white' noise (not gaussian, the colour...).
    %       - Shape-based tweaks? (e.g.: specific morphological filters and
    %       combine them==> with logical or: 'is there a circle OR triangle...)
    %       - Something else?
    %
    %
    %
    % FOR VALIDATION: the results are quite worse, mainly with precision
    % indicating that we are introducing a bit of overfitting:
    % Results with the pseudo optimal threshold = 4 (FR all).
    % Prm. ==> Precision; 	 Accuracy; 	 Recall; 	 Fmeasure; 	 pixelTP; 	 pixelFP; 	 pixelFN; 	 timexFrame
    % Res. ==> 0.6021 	 0.9971 	 0.6985 	 0.6468 	 0.0027 	 0.0018 	 0.0012 	 0.2007
    %
    % With 4.5 in validation, the results are far better (so there are more FP
    % at a similar threshold in validation)
    % ----------------------------------------------------
    % Prm. ==> Precision; 	 Accuracy; 	 Recall; 	 Fmeasure; 	 pixelTP; 	 pixelFP; 	 pixelFN; 	 timexFrame
    % Res. ==> 0.6890 	 0.9976 	 0.6993 	 0.6941 	 0.0027 	 0.0012 	 0.0012 	 0.2056
    
end