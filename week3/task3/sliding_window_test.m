addpath("../../evaluation");
path = "../../../datasets/trafficsigns/m1/train";

pkg load image
pkg load io
pkg load statistics

pixelTP=0; pixelFN=0; pixelFP=0; pixelTN=0;
processing_times = [];

files = dir( strcat(path, "/*.png") );

for i = 2:2 %size(files)
  image = imread(strcat(path, '/', files(i).name))>0;
  
  tic;

  rectangles = sliding_window(image);
  
  imshow(image)
  hold on;
  for i = 1:size(rectangles)
    rectangle('Position', rectangles(i,:), 'EdgeColor','g');
  end
  
  
  time = toc;
  processing_times = [processing_times; time];
  
  %{
  pixelAnnotation = imread(strcat(path, '/mask/mask.', files(i).name(1:size(files(i).name,2)-3), 'png'))>0;
  figure, imshow(pixelAnnotation)
  [localPixelTP, localPixelFP, localPixelFN, localPixelTN] = PerformanceAccumulationPixel(result, pixelAnnotation);
  pixelTP = pixelTP + localPixelTP;
  pixelFP = pixelFP + localPixelFP;
  pixelFN = pixelFN + localPixelFN;
  pixelTN = pixelTN + localPixelTN;  
  %}
end

%{
total = pixelTP + pixelFP + pixelFN + pixelTN;
[pixelTP, pixelFP, pixelFN, pixelTN] / total

[pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity] = PerformanceEvaluationPixel(pixelTP, pixelFP, pixelFN, pixelTN);
[pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity]
  
recall = pixelTP / (pixelTP + pixelFN)
%}

mean(processing_times)