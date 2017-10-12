function [filteredMask]= morphFilterMask(mask)
%{
Martí Cobos
Master in Computer Vision
Computer Vision Center, Barcelona
---------------------------
Project M1/Block2
---------------------------
This function is used to apply morphological operators to a mask segmented by color.
input: - mask: the input mask to be filtered
output:- filteredMmask: the masks filtered with morphological operators from the input mask
---------------------------
%}
% Convert image to HSV color space


SE = strel('disk',20);
filteredMask = imclose(mask, SE);

%Filter small pixels out of bright or dark areas
SE = strel('disk',5);
filteredMask = imopen(filteredMask, SE);
filteredMask = imclose(filteredMask, SE);

end