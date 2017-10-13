%% Script to test custom morphological function and filters
I = imread('cameraman.tif');
SE = strel('diamond', 3);

% Erosion
imErode = team4_erode(I, SE);

% Dilation
imDilate = team4_erode(I, SE);

% Opening
imOpen = team4_open(I, SE);

% Closing
imClose = team4_close(I, SE);

% Top-hat
imTopHat = team4_tophat(I, SE);

% Dual top-hat (bottom hat)
imDualTopHat = team4_dualtophat(I, SE);

figure('Name', 'Morphological operators and filters (example)');
subplot(2,4,1);
imshow(I, []);
title('Original');

subplot(2,4,2);
imshow(imErode, []);
title('Erosion');

subplot(2,4,3);
imshow(imErode, []);
title('Dilation');

subplot(2,4,4);
imshow(imOpen, []);
title('Opening');

subplot(2,4,6);
imshow(imClose, []);
title('Closing');

subplot(2,4,5);
imshow(SE.Neighborhood,[0,1]);
title('SE');

subplot(2,4,7);
imshow(imTopHat, []);
title('Top-hat');

subplot(2,4,8);
imshow(imDualTopHat, []);
title('Dual Top-hat');