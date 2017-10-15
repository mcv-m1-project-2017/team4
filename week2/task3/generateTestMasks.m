close all;
clear;
addpath('../../evaluation');
addpath('../colorSegmentation');

pixelTP=0; pixelFN=0; pixelFP=0; pixelTN=0;
processingTimes = [];
pecstrum = zeros(1,80);

plotImgs = false;
plotGran = true;

dataset = 'test';
root = fileparts(fileparts(fileparts(pwd)));
path = fullfile(root, 'datasets', 'trafficsigns', dataset);
resultFolder =  fullfile(root,'m1-results','week2','test','method1');

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
  segmentationMask = colorSegmentation( image );
  
  %Apply morphlogical operators to improve mask
  filteredMask = morphFilterMask(segmentationMask);
%    filteredMask = segmentationMask;
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
          pecstrum = granulometry(segmentationMask,'disk',maxSize);
          derivative = [-diff(pecstrum) 0];
          subplot(2,2,3), plot(x,derivative),grid, title('Derivate Granulometry with a ''disk'' as SE');
      end
      
  end
  processingTimes = [processingTimes; time];
  imwrite(filteredMask,strcat(resultFolder, '/',files(i).name(1:size(files(i).name,2)-3), 'png'));

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
fprintf('----------------------------------------------------\n');
fprintf('Algorithm results: pixelPrecision; pixelAccuracy; pixelRecall; Fmeasure; pixelTP; pixelFP; pixelFN; timePerFrame');
[pixelPrecision pixelAccuracy pixelRecall FMeasure pixelTP pixelFP pixelFN timePerFrame]
