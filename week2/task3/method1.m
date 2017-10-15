addpath("../../evaluation");
addpath("../colorSegmentation");
%path = "../../../../datasets/trafficsigns/t";
path = "../../../../datasets/trafficsigns/test";

pkg load image
pkg load io
pkg load statistics

processing_times = [];

files = dir( strcat(path, "/*.jpg") );

for i = 1:size(files)
disp(files(i).name)
%if strcmp(files(i).name,"00.004936.jpg") == 1
  image = imread(strcat(path, '/', files(i).name));
  %segmentation_mask = compute_mask_using_max( image );
  
  %figure, imshow(image)
  segmentation_mask = colorSegmentation( image );
  %imshow(segmentation_mask)
  
  %tic;
  
  % your morphology code here
  
  
  result = segmentation_mask;  
  
  tic;
  
  %figure, imshow(result)
  result = imfill(result, 'holes');
  %figure, imshow(result)  
  result = imopen(result, strel('square',20));
  %figure, imshow(result)

  %result = bwpropfilt(result, 'Area', [1, 4000]);
  %figure, imshow(result)
  %result = imclose(result, strel('square', x));
  
  imwrite(result,strcat('/tmp/results/method1/mask.', files(i).name(1:size(files(i).name,2)-3), 'png'));
  
  %{
  image = segmentation_mask;
  granul = [];
  for i = 1:3
    SE = ones((11-i)*5);
    closing = imerode(imdilate(image,SE),SE);
    granul = [granul; sum(closing(:))];
  end
  granul = [granul; sum(image(:))];
  for j = 1:3
    SE = ones(j*5);
    opening = imdilate(imerode(image,SE),SE);
    granul = [granul; sum(opening(:))];
  end
  
  figure, plot(granul)
  figure, plot(diff(granul))
  
  imwrite(result, strcat("/tmp/masks/morph/", files(i).name));
  %figure, imshow(segmentation_mask)
  %figure, imshow(result)
  %figure, imshow(image)
  %}
  
  time = toc;
  processing_times = [processing_times; time];
  
%end
end

mean(processing_times)

