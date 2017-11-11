function [final_mask] = test_watershed(I, geometricFeatures, params)
% IMPORTANT!!! TESTED WITH TRAIN, does not work well
% I = imread('00.005894.jpg');
% load('GeometricConstraints_params_v2.mat')
% load('GeometricFeatures_train.mat')
% MEDIAN
med_I = medfilt3(I);

% HSV-BASED COLOUR SEGMENTATION
col_med = colorSegmentation(med_I);

% MORPHOLOGY
filt_colMed = imfill(col_med,'holes');
filt_colMed_open = imopen(filt_colMed, strel('square', 20));

% INVERSE OF DISTANCE TRANSFORM AND WATERSHED (conn = 4)
% Separates overlapped CC ==> APPLY BEFORE GEOMETRICAL CONSTRAINTS!
DT = bwdist(~filt_colMed_open);
DT_compl = -DT;
DT_compl(~filt_colMed_open) = Inf;
L = watershed (DT_compl);
L(~filt_colMed_open) = 0;
post_watershed = L > 0;

% GEOMETRICAL CONSTRAINTS
[CC, CC_stats] = computeCC_regionProps(post_watershed);
[final_mask, ~, ~] = applyGeometricalConstraints(post_watershed,...
CC, CC_stats, geometricFeatures, params);


% rgb = label2rgb(L,'jet',[.5,.5,.5]);
% figure
% imshow(rgb,'InitialMagnification','fit')
% title('Watershed transform of D')
% figure, imshow(L,[])

% Final mask as all regions returned by watershed

% figure, imshow(final_mask,[]);



