%% METHOD 4
close all;
clear;
addpath('../../evaluation');
addpath('../colorSegmentation');

pixelTP=0; pixelFN=0; pixelFP=0; pixelTN=0;
processingTimes = [];

plotImgs = false;
plotGran = true;

dataset = 'validation';%'validation';%'train';
root = fileparts(fileparts(fileparts(pwd)));
path = fullfile(root, 'datasets', 'trafficsigns', dataset);

%Get image files
files = dir( strcat(path, '/*.jpg') );

% ------------LOOP TESTING PARAMETERS COMBINATIONS---------------------
% DIfferent parameters values to try:
% - 1st open and close, close triangular signals and imfill left fixed.
% - 2nd open and 2nd close, try disk with size 1:1:10
% - 3rd close(after hole filling): ceil(linspace(5,18,10))
% - final dilate: disk from 1:1:10 size.
% The input parameter 'idx' will dictate which combination of the ndgrid of
% parameters gets evaluated in that iteration.
% --------------------------------------------------------------

% secondOpen_sz = [3,5,7,9,11];
% secondClose_sz = [3,5,7,9,11];
% thirdClose_sz = ceil(linspace(8,15,5));
% dilate_sz = [3,5,7,9,11];
% 
% % Create ND grid with all possible combinations of sizes
% [scndOpen_grd, secndClose_grd, thrdClose_grd, dilate_grd] = ndgrid...
%     (secondOpen_sz, secondClose_sz, thirdClose_sz, dilate_sz);
% % 1 idx from 1 to 3^4 (combinations possible) to retrive the correct value
% 
% % IN TRAINING AND THEN TESTING IN VALIDATION THE BEST ONE
% valuesPerParameter = 5;
% tweakedParameters = 4;
% numCombinations = valuesPerParameter^(tweakedParameters);
% results_mtx_train =  zeros(numCombinations, 8); % 8 reported stats (precision, recall, F-sc....)
% res_labels_combination = zeros(numCombinations, 4);

% Load threshold
load('AreaFillingFormFactor_trainingOld.mat')
% % Max
% lowerBound = 0.8; upperBound = 1.3;
% numThr = 5;
% thrCandidates = linspace(lowerBound,upperBound,numThr);
% % Min
% lowerBound = 0.8; upperBound = 1.3;
% minThrCandidates = linspace(upperBound, lowerBound, numThr);
% [Max_thr, Min_thr] = ndgrid(thrCandidates, minThrCandidates);
% numParams = 2;
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
  segmentationMask = colorSegmentation( image );
  
  %Apply morphlogical operators to improve mask
%   filteredMask = morphFilterMask_v2(segmentationMask,...
%       [scndOpen_grd(p), secndClose_grd(p), thrdClose_grd(p), dilate_grd(p)]);
%    filteredMask = segmentationMask;
filteredMask = morphFilterMask_method4(segmentationMask, fillFormArea_stats);
    %Max_thr(t), Min_thr(t));

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
fprintf('Algorithm results: pixelPrecision; pixelAccuracy; pixelRecall; Fmeasure; pixelTP; pixelFP; pixelFN; timePerFrame');
 [pixelPrecision pixelAccuracy pixelRecall FMeasure pixelTP pixelFP pixelFN timePerFrame]
%  end
%-------TESTS WITH MULTIPLE PARAMETERS VALUES----
% After printing the values for the current iteration, save it taking into
% account the p so we can retrieve tha parameter values that yielded
% % those results!
% results_mtx_train(p,:) = [pixelPrecision pixelAccuracy pixelRecall FMeasure pixelTP pixelFP pixelFN timePerFrame];
% res_labels_combination(p,:) = [scndOpen_grd(p), secndClose_grd(p), thrdClose_grd(p), dilate_grd(p)];
% end
%save('results_trainingDiffParams.mat', 'results_mtx_train', 'res_labels_combination');