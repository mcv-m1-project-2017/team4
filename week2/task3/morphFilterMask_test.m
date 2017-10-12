close all;
clear;
addpath('../../evaluation');
addpath('../colorSegmentation');

pixelTP=0; pixelFN=0; pixelFP=0; pixelTN=0;
processing_times = [];

plot = false;

dataset = 'train';
root = fileparts(fileparts(fileparts(pwd)));
path = fullfile(root, 'datasets', 'trafficsigns', dataset);

%Get image files
files = dir( strcat(path, '/*.jpg') );

%Analyse images in path
for i = 1:size(files)
  
  %Read RGB iamge
  fprintf('----------------------------------------------------\n');
  fprintf('Analysing image number  %d', i);
  image = imread(strcat(path, '/', files(i).name));
  tic;
  %Apply HSV color segmentation to generate image mask
  segmentation_mask = colorSegmentation( image );
  
  %Apply morphlogical operators to improve mask
  filtered_mask = morphFilterMask(segmentation_mask);
  
  %Compute time per frame
  time = toc;
  if (plot)
      subplot(2,2,1), imshow(image);
      subplot(2,2,2), imshow(segmentation_mask);
      subplot(2,2,3), imshow(filtered_mask);
      
  end
  processing_times = [processing_times; time];
  
  %Compute image TP, FP, FN, TN
  pixelAnnotation = imread(strcat(path, '/mask/mask.', files(i).name(1:size(files(i).name,2)-3), 'png'))>0;
  [localPixelTP, localPixelFP, localPixelFN, localPixelTN] = PerformanceAccumulationPixel(filtered_mask, pixelAnnotation);
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
timePerFrame = mean(processing_times);

%Print results in array format
fprintf('----------------------------------------------------\n');
fprintf('Algorithm results: pixelPrecision; pixelAccuracy; pixelRecall; Fmeasure; pixelTP; pixelFP; pixelFN; timePerFrame');
[pixelPrecision pixelAccuracy pixelRecall FMeasure pixelTP pixelFP pixelFN timePerFrame]
