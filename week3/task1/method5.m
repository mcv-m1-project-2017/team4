function [filteredMask]= method5(mask)
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
% List of params contains the parameter values for iteration 'p' (see
% morphFilterMask_method4_test for more info.

%Filter small pixels out of bright or dark areas (noise filtering)

% SE = strel('disk',3);
% filteredMask = imopen(filteredMask, SE);
% filteredMask = imclose(filteredMask, SE);

%Close triangular signals
% SE = strel('diamond',30);
% filteredMask = imclose(filteredMask, SE);
% Close signals:
filteredMask = imclose(mask, strel('rectangle', [3,7]));
filteredMask = imfill(mask, 'holes');
filteredMask = imclose(filteredMask, strel('disk',30));


%Filter big pixels out of bright or dark areas (second noise filtering)
%SE = strel('disk',5); %7-> recall 75
SE_open = strel('disk', 5);%listParams(1));
SE_close = strel('disk', 5);%listParams(2));
filteredMask = imopen(filteredMask, SE_open);
filteredMask = imclose(filteredMask, SE_close);

% Hole filling the final selection
% filteredMask = imfill(filteredMask, 'holes');

% Close +  dilation to enlarge the detection as signals
SE_lastClose = strel('disk',20);%listParams(3));
SE_dilation = strel('square',3);%listParams(4));
filteredMask = imclose(filteredMask, SE_lastClose); % maybe not worth it
% filteredMask = imfill(filteredMask, 'holes');
%filteredMask = imdilate(filteredMask, SE_dilation);

%% Testing results:
% Method 5 + max and min area constraints
% pixelPrecision; pixelAccuracy; pixelRecall; Fmeasure; pixelTP; pixelFP; pixelFN; timePerFrame
%    0.2890         0.9911          0.8291    0.4286    0.0033    0.0082    0.0007  0.6325

end