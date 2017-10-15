addpath("../../evaluation");
addpath("../colorSegmentation");
path = "../../../../datasets/trafficsigns/v";

pkg load image
pkg load io
pkg load statistics

pixelTP=0; pixelFN=0; pixelFP=0; pixelTN=0;

processing_times = [];

files = dir( strcat(path, "/*.jpg") );
for i = 1:size(file_list)
  tic;
  image = imread(strcat(path, '/', files(i).name));
  %segmentation_mask = compute_mask_using_max( image );
  segmentation_mask = colorSegmentation( image );
  %imshow(segmentation_mask)

  %tic;

  % your morphology code here

  time = toc;
  processing_times = [processing_times; time];

  pixelAnnotation = imread(strcat(path, '/mask/mask.', files(i).name(1:size(files(i).name,2)-3), 'png'))>0;
  [localPixelTP, localPixelFP, localPixelFN, localPixelTN] = PerformanceAccumulationPixel(segmentation_mask, pixelAnnotation);
  pixelTP = pixelTP + localPixelTP;
  pixelFP = pixelFP + localPixelFP;
  pixelFN = pixelFN + localPixelFN;
  pixelTN = pixelTN + localPixelTN;


end

total = pixelTP + pixelFP + pixelFN + pixelTN;
[pixelTP, pixelFP, pixelFN, pixelTN] / total

[pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity] = PerformanceEvaluationPixel(pixelTP, pixelFP, pixelFN, pixelTN);
[pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity]

mean(processing_times)
