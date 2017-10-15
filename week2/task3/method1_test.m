addpath('../colorSegmentation');
path = '../../../../datasets/trafficsigns/test';

processing_times = [];

files = dir( strcat(path, "/*.jpg") );

for i = 1:size(files)
  image = imread(strcat(path, '/', files(i).name));

  tic;

  segmentation_mask = colorSegmentation( image );
  result = segmentation_mask;  
  result = imfill(result, 'holes');
  result = imopen(result, strel('square',20));
  
  time = toc;
  processing_times = [processing_times; time];
end

mean(processing_times)

