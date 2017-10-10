function [mask]=ColorSegmentation(image,color)
%{
Juan Felipe Montesinos
Yi Xiao
Ferran Carrasquer Mas
Master in Computer Vision
Computer Vision Center, Barcelona
---------------------------
Project M1/Block1
---------------------------
This function is used to generate masks for color segmentation in HSV color space.
input: - image: the images we need to create masks for
       - color: which color of signals we want to segment
                'blue': blue signals
                'red': red signals
output:- mask: the masks generated for the input images
---------------------------
%}
% Convert image to HSV color space
 image_hsv = colorspace('rgb-> hsv',image);
 
 % Split the channels
 h = image_hsv(:,:,1);
 s = image_hsv(:,:,2);
 v = image_hsv(:,:,3);
 
 % Create a blank mask
 [row,colum,c]=size(image_hsv);
 mask = zeros(row,colum);
 
if strcmp(color,'blue')==1
% Segmentation for blue signals
  for i=1:row
    for j=1:colum
        if h(i,j) < 230 && h(i,j) > 180 && s(i,j) > 50/100
           mask(i,j)=1;
        else
           mask(i,j)=0;
        end
    end
  end
 mask=uint8(mask);
elseif strcmp(color,'red')==1
% Segmentation for red signals
  for i=1:row
    for j=1:colum
        if ((h(i,j) < 10 && h(i,j) >= 0) || (h(i,j) <= 360 && h(i,j) > 350)) && (s(i,j) > 50/100) && (v(i,j) > 25/100)
           mask(i,j)=1;
        else
           mask(i,j)=0;
        end
    end
  end
  mask=uint8(mask);
else
    error('Bad input arguments')
end