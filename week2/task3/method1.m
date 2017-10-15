addpath('../../evaluation');
addpath('../colorSegmentation');
path = '../../../datasets/trafficsigns/validation';

pixelTP=0; pixelFN=0; pixelFP=0; pixelTN=0;
processing_times = [];

files = dir( strcat(path, '/*.jpg') );
for i = 1:size(files)
  image = imread(strcat(path, '/', files(i).name));

  tic;
  
  % HSV color segmentation
  segmentation_mask = colorSegmentation( image );
  result = segmentation_mask;

  % Area filling
  result = imfill(result, 'holes');

  % Noise reduction
  result = imopen(result, strel('square',20));
  
  time = toc;
  processing_times = [processing_times; time];
  
  pixelAnnotation = imread(strcat(path, '/mask/mask.', files(i).name(1:size(files(i).name,2)-3), 'png'))>0;
  [localPixelTP, localPixelFP, localPixelFN, localPixelTN] = PerformanceAccumulationPixel(result, pixelAnnotation);
  pixelTP = pixelTP + localPixelTP;
  pixelFP = pixelFP + localPixelFP;
  pixelFN = pixelFN + localPixelFN;
  pixelTN = pixelTN + localPixelTN;    
end

total = pixelTP + pixelFP + pixelFN + pixelTN;
[pixelTP, pixelFP, pixelFN, pixelTN] / total

[pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity] = PerformanceEvaluationPixel(pixelTP, pixelFP, pixelFN, pixelTN);
[pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity]
  
recall = pixelTP / (pixelTP + pixelFN)

mean(processing_times)

