%% TEST FOR METHOD 5 WITH GEOMETRIC CONSTRAINTS (independent functions)
%close all;
clear;
addpath(genpath('../../../'));

pixelTP=0; pixelFN=0; pixelFP=0; pixelTN=0;
processingTimes = [];

plotImgs = false;
plotGran = true;

dataset = 'train';%'validation';%'train';
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

%
% % IN TRAINING AND THEN TESTING IN VALIDATION THE BEST ONE
% valuesPerParameter = 5;
% tweakedParameters = 4;
% numCombinations = valuesPerParameter^(tweakedParameters);
% results_mtx_train =  zeros(numCombinations, 8); % 8 reported stats (precision, recall, F-sc....)
% res_labels_combination = zeros(numCombinations, 4);
% idx will run through the

% Load threshold
load('GeometricFeatures_train.mat')
% Start with initial thresholds, only one iteration ==> idx = 1
idx = 1;

% numCombinations = numThr^(numParams);
% % for p = 1:numCombinations
% %     % train with these parameters values (loop for all images).
% for t=1:numCombinations
%Analyse images in path
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
    filteredMask = imopen(filteredMask, strel('square', 20));
    filteredMask = method5_geometricalConstraints(filteredMask,...
       geometricFeatures, idx);

    
    %Compute time per frame
    time = toc;
    
    %Show images in figure
    if (plotImgs)
        
        subplot(2,2,1), imshow(image);
        subplot(2,2,2), imshow(segmentationMask);
        subplot(2,2,4), imshow(filteredMask);
        if (plotGran)
            %Compute image granulometry
            maxSize = 30;
            x =((1-maxSize):maxSize);
            pecstrum = granulometry(filteredMask,'diamond',maxSize);
            derivative = [-diff(pecstrum) 0];
            subplot(2,2,3), plot(x,derivative),grid, title('Derivate Granulometry with a ''diamond'' as SE');
        end
        
    end
    processingTimes = [processingTimes; time];
    
    %Compute image TP, FP, FN, TN
    pixelAnnotation = imread(strcat(path, '/mask/mask.', files(i).name(1:size(files(i).name,2)-3), 'png'))>0;
    [localPixelTP, localPixelFP, localPixelFN, localPixelTN] = PerformanceAccumulationPixel(filteredMask, pixelAnnotation);
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
fprintf('----------------------------------------------------\n');
fprintf('Prm. ==> Precision; \t Accuracy; \t Recall; \t Fmeasure; \t pixelTP; \t pixelFP; \t pixelFN; \t timexFrame\n');
fprintf('Res. ==> %.4f \t %.4f \t %.4f \t %.4f \t %.4f \t %.4f \t %.4f \t %.4f\n',...
    pixelPrecision, pixelAccuracy, pixelRecall,FMeasure, pixelTP, pixelFP,...
    pixelFN, timePerFrame);
%  end
%-------TESTS WITH MULTIPLE PARAMETERS VALUES----
% After printing the values for the current iteration, save it taking into
% account the p so we can retrieve tha parameter values that yielded
% % those results!
% results_mtx_train(p,:) = [pixelPrecision pixelAccuracy pixelRecall FMeasure pixelTP pixelFP pixelFN timePerFrame];
% res_labels_combination(p,:) = [scndOpen_grd(p), secndClose_grd(p), thrdClose_grd(p), dilate_grd(p)];
% end
%save('results_trainingDiffParams.mat', 'results_mtx_train', 'res_labels_combination');