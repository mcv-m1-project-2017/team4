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
This function is used to generate masks for color segme;ntation in HSV color space.
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
 hred = [350 20];
 hblueA = [180 250];
 hblueB = [210 300];
 sred = 0.45;
 sblueA = 0.4;
 sblueB = [0.15 0.4];
 vred = 0;%0.25;
 vblueB = 0.3;
 
 
 %Create red and blue masks
  red = ((((h<hred(2))&(h>=0))|((h<=360)&(h>hred(1))))&(s>sred)&(v>vred));
  blueA = ((h<hblueA(2)) & (h>hblueA(1)) & (s>sblueA));
  blueB = ((h<hblueB(2)) & (h>hblueB(1)) & (s>sblueB(1)) & (s<sblueB(2))) &(v<vblueB);

 %Create final mask
 mask = red |blueA|blueB;

end
