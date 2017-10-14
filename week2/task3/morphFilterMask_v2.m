function [filteredMask]= morphFilterMask_v2(mask)
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
SE = strel('disk',7);
filteredMask = imopen(filteredMask, SE);
filteredMask = imclose(filteredMask, SE);

% Hole filling the final selection
filteredMask = imfill(filteredMask, 'holes');

% Small dilation
filteredMask = imclose(filteredMask, strel('disk',1));

%% Current results (as of 14/09/2017 02:33 AM
% (pixelPrecision; pixelAccuracy; pixelRecall; Fmeasure; pixelTP; pixelFP; pixelFN; timePerFrame)
% 0.2776            0.9915          0.7574      0.4063    0.0029    0.0076    0.0009    0.3786

end