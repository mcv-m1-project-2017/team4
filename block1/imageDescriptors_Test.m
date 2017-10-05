

BB = [113.190000 1291.880000 175.660000 1361.820000];
% img = imread('C:\Users\Marti\Desktop\MCV\M1-IHCV\Project\train\00.000977.jpg');
% mask = imread('C:\Users\Marti\Desktop\MCV\M1-IHCV\Project\train\mask\mask.00.000977.png');
img = imread('..\train\00.000977.jpg');
mask = imread('..\train\mask\mask.00.000977.png');
descriptors = imageDescriptors (img, mask, BB);