function [filteredMask]= morphFilterMask(mask)
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
This function is used to apply morphological operators to a mask segmented by color.
input: - mask: the input mask to be filtered
output:- filteredMmask: the masks filtered with morphological operators from the input mask
---------------------------
%}


%Filter small pixels out of bright or dark areas
SE = strel('disk',3);
filteredMask = imopen(mask, SE);
filteredMask = imclose(filteredMask, SE);

%Close triangular signals
SE = strel('diamond',30);
filteredMask = imclose(filteredMask, SE);

%Filter big pixels out of bright or dark areas
SE = strel('disk',5);
filteredMask = imopen(filteredMask, SE);
filteredMask = imclose(filteredMask, SE);


end