%% Script to test if luminance normalization improves some segmentation results

% First, colorConstancy.m and highlightReconstruction.m are called with the
% same sample image to show the obtained image.

% For all images, the unprocessed image' figure is titled 'original',
% whereas the processed one has the title of the particular technique
% applied.
colorConstancy_test;        % White patch, modified white patch & grey world
highlightReconstruction_test; % Reconstruction in RGB, HSV and HSL with 
                              % different 'clipping' thresholds is shown.

% Secondly, the segmentation outputs for the images outputted above are
% also displayed and compared against the segmentation results with no
% luminance normalization.

%********************************************************************
% COMPLETE WHEN TASK 3 AND 4 ARE FINISHED (run it solely for the above
% image example)!
%*********************************************************************