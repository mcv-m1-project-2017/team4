function [evaluationParameters, windowCandidates] = Test_morphGeometricConstraints(geometricFeatures,...
    params, dataset_name)
% TEST_MORPHGEOMETRICCONSTRAINTS.m: function to test different thresholds
% for the geometrical parameters defined in 'geometricFeatures' for dataset
% 'dataset_name'. 'params' are factors to scale such thresholds.
%
%   Input parameters
%
%       - geometricFeatures:        vector of geometric features loaded from
%                                   'GeometricFeatures_train.mat'.
%
%       - params:                   scale parameters to fine-tune thresholds.
%
%       - dataset_name:             datasen chosen ('validation' or 'test').
%
%   Output parameters
%
%       - evaluationParameters:     pixel-based evaluation measurements
%                                   (precision, accuracy, recall, fmeasure,
%                                   pixelTP, pixelFP pixelTN and TimePerFrame).
%
%       - windowCandidates:         list of detections' bounding boxes.
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
%   Project M1/Block3
%   -----------------

pixelTP=0; pixelFN=0; pixelFP=0; pixelTN=0;
processingTimes = [];

plotImgs = false;
plotGran = true;

dataset = dataset_name;%'train';%'validation';%'train';
root = fileparts(fileparts(fileparts(pwd)));
path = fullfile(root, 'datasets', 'trafficsigns', dataset);

%Get image files
files = dir( strcat(path, '/*.jpg') );

% ----TEST DIFFERENT THRESHOLDS FOR AREA, ASPECT RATIO AND FILLING RATIO---
%   - Thresholds based on the max, min, mean and std of each feature
%
%   * Initial proposals:
%       - Area: limit on a*minArea < allowedArea < b*maxArea(**)
%       - Aspect ratio: limit on mean(AR)+-a*std(AR) (***)
%       - Filling ratio: (****)
%           - Triangular signals: mean(FR_tri)+a*std(FR_tri)
%           - Circular/round ": mean(FR_circ)+a*std(FR_circ)
%           - Rectangular ": mean(FR_rect)+a*std(FR_rect)
%
% (**) initial thresholds can be those used in week 2 (only as reference)
% (***) a: in the range [1,4]. If there is time even try slightly <1
% (****) seeing the stats, a should be small, specially for triangular
% signals that have low variance and slightly overlap with round ones.
% --------------------------------------------------------------

% % ------------------------ DEFINE TRAINING VALUES -----------------------
% % IN TRAINING AND THEN TEST IN VALIDATION THE BEST ONE
% %  Compute nº of combinations and define parameters values
% valuesPerParameter = 5;
% tweakedParameters = 2;
% numCombinations = valuesPerParameter^(tweakedParameters);
% results_mtx_train =  zeros(numCombinations, 8); % 8 reported stats (precision, recall, F-sc....)
% res_params_values = zeros(numCombinations, 2);
% % Parameter values
% % testFR_tri = linspace(3.6,4.4,5);%[4, 4.25, 5];
% % testFR_circ = linspace(3.6,4.4,5);%[4.5, 4.75, 5];
% % testFR_rect = linspace(3.6,4.4,5);%[4.5, 4.75, 5];
%
% % Testing values (NDGRID)
% %[vec_FR_tri, vec_FR_circ, vec_FR_rect] = ndgrid(testFR_tri, testFR_circ, testFR_rect);
% % Pass to the function these 3 output vectors that contain all the possible
% % combination of parameter values.
%
% % Test aspect ratio and max min size thresholds.
% testMinArea_thr = linspace(1.7, 2, 5);
% testMaxArea_thr = linspace(1, 1.3, 5);
% % testScaleStd_AR = linspace(2, 4, 5);
% %
% % [vecMinArea, vecMaxArea, vecStdAR] = ndgrid(testMinArea_thr, testMaxArea_thr, testScaleStd_AR);
% [vecMinArea, vecMaxArea] = meshgrid(testMinArea_thr, testMaxArea_thr);
% vecMinArea = vecMinArea(:);
% vecMaxArea = vecMaxArea(:);
% Load threshold
% load('GeometricFeatures_train.mat')


for i = 1:size(files)
    %Read RGB iamge
    %fprintf('----------------------------------------------------\n');
    %fprintf('Analysing image number  %d', i);
    image = imread(strcat(path, '/', files(i).name));
    tic;
    %Apply HSV color segmentation to generate image mask
    segmentationMask = colorSegmentation(image);
    
    %Apply morphlogical operators to improve mask
    % Method 5
    %     filteredMask = method5(segmentationMask);
    %     filteredMask = method5_geometricalConstraints(filteredMask,...
    %         geometricFeatures, idx);
    % Test simplest yet effective method 1 (the best for test)
    
    filteredMask = imfill(segmentationMask, 'holes');
    filteredMask_2 = imopen(filteredMask, strel('square', 20));
    %         filteredMask_2 = imclose(filteredMask_2, strel('disk',2));
    % EXPERIMENTAL: opening by reconstruction of erosion (SAME RESULTS)
    %             marker = imerode(filteredMask, strel('square', 15));
    %             mask = filteredMask;
    %             filteredMask = imreconstruct(marker, mask);
%     filteredMask_3 = method5_geometricalConstraints(filteredMask_2,...
%         geometricFeatures, params);%vecMinArea(p), vecMaxArea(p), vecStdAR(p));%,0,0,0);%vec_FR_tri(p), vec_FR_circ(p), vec_FR_circ(p));
    %filteredMask = imclose(filteredMask, strel('disk', 3));
    [CC, CC_stats] = computeCC_regionProps(filteredMask_2);
    [filteredMask_3, windowCandidates, isSignal] = applyGeometricalConstraints(filteredMask_2,...
    CC, CC_stats, geometricFeatures, params);
    
    
    %Compute time per frame
    time = toc;
    
    %Show images in figure
    if (plotImgs)
        
        subplot(2,2,1), imshow(image);
        subplot(2,2,2), imshow(segmentationMask);
        subplot(2,2,4), imshow(filteredMask_3);
        if (plotGran)
            %Compute image granulometry
            maxSize = 30;
            x =((1-maxSize):maxSize);
            pecstrum = granulometry(filteredMask_3,'diamond',maxSize);
            derivative = [-diff(pecstrum) 0];
            subplot(2,2,3), plot(x,derivative),grid, title('Derivate Granulometry with a ''diamond'' as SE');
        end
        
    end
    processingTimes = [processingTimes; time];
    
    %Compute image TP, FP, FN, TN
    pixelAnnotation = imread(strcat(path, '/mask/mask.', files(i).name(1:size(files(i).name,2)-3), 'png'))>0;
    [localPixelTP, localPixelFP, localPixelFN, localPixelTN] = PerformanceAccumulationPixel(filteredMask_3, pixelAnnotation);
    pixelTP = pixelTP + localPixelTP;
    pixelFP = pixelFP + localPixelFP;
    pixelFN = pixelFN + localPixelFN;
    pixelTN = pixelTN + localPixelTN;
    
end

%Compute algorithm precision, accuracy, specificity, recall and fmeasure
[pixelPrecision, pixelAccuracy, pixelSpecificity, pixelRecall] = PerformanceEvaluationPixel(pixelTP, pixelFP, pixelFN, pixelTN);
FMeasure = 2*(pixelPrecision*pixelRecall)/(pixelPrecision+pixelRecall);
total = pixelTP + pixelFP + pixelFN + pixelTN;
pixelTP = pixelTP / total;
pixelFP = pixelFP / total;
pixelFN = pixelFN / total;

%Get time per frame mean
timePerFrame = mean(processingTimes);

%Print results in array format
% fprintf('Results with max thr.: %f and min thr.: %f\n', Max_thr(t),...
%     Min_thr(t));
% fprintf('Results for FR parameters: triangle ==> %.4f circular ==> %.4f rectangular ==> %.4f\n',...
%     vec_FR_tri(p), vec_FR_circ(p), vec_FR_rect(p));
% fprintf('Results for area/AR: minArea ==> %.4f maxArea ==> %.4f std AR ==> %.4f\n',...
%     vecMinArea(p), vecMaxArea(p), vecStdAR(p));
fprintf('Results for area/AR: minArea ==> %.4f maxArea ==> %.4f scaleStdAR ==> %.4f FR_tri ==> %.4f FR_circ ==> %.4f FR_rect ==> %.4f\n',...
    params(1), params(2), params(3), params(4), params(5), params(6));
fprintf('----------------------------------------------------\n');
fprintf('Prm. ==> Precision; \t Accuracy; \t Recall; \t Fmeasure; \t pixelTP; \t pixelFP; \t pixelFN; \t timexFrame\n');
fprintf('Res. ==> %.4f \t %.4f \t %.4f \t %.4f \t %.4f \t %.4f \t %.4f \t %.4f\n',...
    pixelPrecision, pixelAccuracy, pixelRecall,FMeasure, pixelTP, pixelFP,...
    pixelFN, timePerFrame);
evaluationParameters = [pixelPrecision, pixelAccuracy, pixelRecall,FMeasure, pixelTP, pixelFP,...
    pixelFN, timePerFrame];
end