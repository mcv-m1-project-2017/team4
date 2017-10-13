function [mask]=colorSegmentation(image)
%{
Jonatan Poveda
Martí Cobos
Juan Francesc Serracant
Ferran Pérez
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
%  image_hsv = colorspace('rgb-> hsv',image);
 image_hsv = rgb2hsv(image);
 
 % Split the channels
 h = image_hsv(:,:,1).*360;
 s = image_hsv(:,:,2);
 v = image_hsv(:,:,3);
 
 % Create a blank mask
 [row,colum]=size(h);
 mask = zeros(row,colum);
 
 %Define Red and blue thresholds
 hred = [350 10];
 hblue = [180 230];
 st = 0.5;
 vt = 0%0.25;
 
 %Create red and blue masks
   red = ((((h<hred(2))&(h>=0))|((h<=360)&(h>hred(1))))&(s>st)&(v>vt));
 blue = ((h<hblue(2)) & (h>hblue(1)) & (s>st));

%  red = ((((h<10)&(h>=0))|((h<=360)&(h>350)))&(s>50/100)&(v>25/100));
%  blue = ((h<230) & (h>180) & (s>50/100));
 %Create final mask
 mask = red |blue;

end
