% Task 2: Template matching using Distance Transform and chamfer distance
do_plots = false;

% Add repository functions to path
addpath(genpath('..'));
addpath(genpath('../task2CircularHough'));


% Set paths
dataset = 'train';
root = '../../..';
inputMasksPath = fullfile(root, 'datasets', 'trafficsigns', 'm1', dataset);
fullImagePath = fullfile(root, 'datasets', 'trafficsigns', 'split', dataset);
gtMasksPath = fullfile(root, 'datasets', 'trafficsigns', 'split', dataset, 'mask');

% Get all the files
inputMasks = dir(fullfile(inputMasksPath, '*.png'));
frames = dir(fullfile(fullImagePath, '*.jpg'));
gtMasks = dir(fullfile(gtMasksPath, '*.png'));


%Get models
tri_down = uint8( imread('tri_down.png') );
tri_up = uint8( imread('tri_up.png') );
squ = uint8( imread('squ.png') );

addpath(genpath('../../../'));
load('GeometricFeatures_train.mat');
load('GeometricConstraints_params_v2.mat');

s = 42;

pixelTP=0; pixelFN=0; pixelFP=0; pixelTN=0;
processingTimes = [];

for i = 1:size(inputMasks,1)
%for i = s:s %1:size(inputMasks,1)
  fprintf('Checking mask %d\n', i)
  inputMaskObject = inputMasks(i);
  inputMaskPath = fullfile(inputMasksPath, inputMaskObject.name);
  iMask = imread(inputMaskPath);
  originalMask = iMask;
  
  frameObject = frames(i);
  framePath = fullfile(fullImagePath, frameObject.name);
  frame = imread(framePath);

  gtMaskObject = gtMasks(i);
  gtMaskPath = fullfile(gtMasksPath, gtMaskObject.name);
  gtMask = uint8(imread(gtMaskPath)) * 255;
  
  %figure, imshow(iMask)
 
  imwrite(frame, ['/tmp/test6/' num2str(i) '_o.png']);
  imwrite(iMask, ['/tmp/test6/' num2str(i) '_o_m.png']);
  imwrite(gtMask, ['/tmp/test6/' num2str(i) '_o_gt.png']);
  
  tic;
  
  linearMask = linearHough(frame, iMask, tri_up, tri_down, squ, i);
  linearMask = linearMask(1:size(frame,1), 1:size(frame,2));
  
  %{
  circularMask = circularHough(frame);
  [CC, CC_stats] = computeCC_regionProps(circularMask);
  [circularMask, windowCandidates] = applyGeometricalConstraints(circularMask,...
            CC, CC_stats, geometricFeatures, params);
  %}
  
  mask = linearMask; % + circularMask;
  %imshow(mask);
  time = toc;
  
  processingTimes = [processingTimes; time];
  
  %Compute image TP, FP, FN, TN
  
  [localPixelTP, localPixelFP, localPixelFN, localPixelTN] = PerformanceAccumulationPixel(mask, originalMask);
  pixelTP = pixelTP + localPixelTP;
  pixelFP = pixelFP + localPixelFP;
  pixelFN = pixelFN + localPixelFN;
  pixelTN = pixelTN + localPixelTN;

  imwrite(linearMask, ['/tmp/test6/' num2str(i) '_o_n.png']);

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
