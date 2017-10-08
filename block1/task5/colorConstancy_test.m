%% Test for colorConstancy.m

addpath(genpath('../../../'));
imgPath = '../../../Datasets/train_2017/train/00.001464.jpg';
I = imread(imgPath);
WP_thr = 200;
outWP = colorConstancy(I, 'WhitePatch');
outMWP = colorConstancy(I, 'ModifiedWhitePatch', WP_thr);
outGW = colorConstancy(I, 'GreyWorld');

% Plot them side by side for comparison purposes:
figure;
subplot(2,2,1);
imshow(I, []);
title('Original image');

subplot(2,2,2);
imshow(outWP,[]);
title('White Patch');


subplot(2,2,3);
imshow(outMWP,[]);
str = ['Modified White Patch with thr= ', num2str(WP_thr)]; 
title(str);


subplot(2,2,4);
imshow(outGW,[]);
title('Grey World');
