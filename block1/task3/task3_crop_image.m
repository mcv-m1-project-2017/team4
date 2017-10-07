function [ crop ] = task3_crop_image ( image_path, limits)
% Given an image and a bounding box crop the image
  % Read image
  image = imread(image_path);
  crop = image(limits(1):limits(2),limits(3):limits(4),:);
end
