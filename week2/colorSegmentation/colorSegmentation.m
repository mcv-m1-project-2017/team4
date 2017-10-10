function [mask]=colorSegmentation(image)
%{
Martí Cobos
Master in Computer Vision
Computer Vision Center, Barcelona
---------------------------
Project M1/Block2
---------------------------
This function is used to generate masks for color segmentation in HSV color space.
input: - image: the images we need to create masks for
output:- mask: the masks generated for the input images
---------------------------
%}
% Convert image to HSV color space
 image_hsv = colorspace('rgb-> hsv',image);
% image_hsv = rgb2hsv(image);
 
 % Split the channels
 h = image_hsv(:,:,1);
 s = image_hsv(:,:,2);
 v = image_hsv(:,:,3);
 
 % Create a blank mask
 [row,colum]=size(h);
 mask = zeros(row,colum);
 
 mask (((h<230) & (h>180) & (s>50/100))|((((h<10)&(h>=0))|((h<=360)&(h>350)))&(s>50/100)&(v>25/100)))= 1;

end
